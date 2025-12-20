import 'dart:async';
import 'package:fasting_use_cases/fasting_use_cases.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:fasting_app/fasting/current_fasting_session/utils/utils.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_repository/fasting_repository.dart'; // FastingWindow comes from here

part 'current_fasting_session_event.dart';
part 'current_fasting_session_state.dart';

class CurrentFastingSessionBloc
    extends Bloc<CurrentFastingSessionEvent, CurrentFastingSessionState> {
  final StartFastUseCase _startFast;
  final EndFastUseCase _endFast;
  final GetActiveFastUseCase _getActiveFast;
  final UpdateActiveFastWindowUseCase _updateActiveFastWindow;
  final UpdateActiveFastStartTimeUseCase _updateActiveFastStartTime;

  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;
  StreamSubscription<SettingsState>? _settingsSubscription;
  Timer? _previewTimer;

  CurrentFastingSessionBloc({
    required StartFastUseCase startFast,
    required EndFastUseCase endFast,
    required GetActiveFastUseCase getActiveFast,
    required UpdateActiveFastWindowUseCase updateActiveFastWindow,
    required UpdateActiveFastStartTimeUseCase updateActiveFastStartTime,
    required SettingsBloc settingsBloc,
    Ticker ticker = const Ticker(),
  })  : _startFast = startFast,
        _endFast = endFast,
        _getActiveFast = getActiveFast,
        _updateActiveFastWindow = updateActiveFastWindow,
        _updateActiveFastStartTime = updateActiveFastStartTime,
        _ticker = ticker,
        super(const CurrentFastingSessionInitial()) {
    on<LoadActiveFast>(_onLoadActiveFast);
    on<FastStarted>(_onFastStarted);
    on<FastEnded>(_onFastEnded);
    on<_TimerTicked>(_onTimerTicked);
    on<UpdateActiveFastWindow>(_onUpdateActiveFastWindow);
    on<UpdateActiveFastStartTime>(_onUpdateActiveFastStartTime);
    on<_PreviewTimerTicked>(_onPreviewTimerTicked);

    // Listen to SettingsBloc changes
    _settingsSubscription = settingsBloc.stream.listen((settingsState) {
      if (settingsState is SettingsLoaded) {
        add(UpdateActiveFastWindow(settingsState.settings.fastingWindow));
      }
    });

    // Start preview timer for initial state
    _startPreviewTimer();
  }

  void _onLoadActiveFast(
    LoadActiveFast event,
    Emitter<CurrentFastingSessionState> emit,
  ) async {
    emit(const CurrentFastingSessionLoading());

    try {
      final activeFastingSession = await _getActiveFast.call();

      if (activeFastingSession != null) {
        final elapsed = DateTime.now().difference(activeFastingSession.start);
        _stopPreviewTimer();
        _startTicker(startFrom: elapsed);

        emit(CurrentFastingSessionInProgress(activeFastingSession, null));
      } else {
        _startPreviewTimer();
        emit(const CurrentFastingSessionReady());
      }
    } catch (e) {
      // TODO:  Log the error
      _startPreviewTimer();
      emit(const CurrentFastingSessionReady());
    }
  }

  void _onFastStarted(
      FastStarted event, Emitter<CurrentFastingSessionState> emit) async {
    final fastingSession = await _startFast.call();
    _stopPreviewTimer();
    _startTicker();

    emit(
      CurrentFastingSessionInProgress(fastingSession, null),
    );
  }

  void _startTicker({Duration startFrom = Duration.zero}) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen(
          (seconds) => add(
            _TimerTicked(
              duration: startFrom + Duration(seconds: seconds),
            ),
          ),
        );
  }

  void _startPreviewTimer() {
    _stopPreviewTimer();
    // Update every minute to refresh the end time preview
    _previewTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (state is CurrentFastingSessionReady) {
        add(const _PreviewTimerTicked());
      }
    });
  }

  void _stopPreviewTimer() {
    _previewTimer?.cancel();
    _previewTimer = null;
  }

  void _onFastEnded(FastEnded event, Emitter<CurrentFastingSessionState> emit) {
    final state = this.state;
    if (state is! CurrentFastingSessionInProgress) return;

    final fastId = state.session.id!;
    _endFast.call(fastId);

    _tickerSubscription?.cancel();
    _startPreviewTimer();
    emit(const CurrentFastingSessionReady());
  }

  void _onTimerTicked(
      _TimerTicked event, Emitter<CurrentFastingSessionState> emit) {
    if (state is! CurrentFastingSessionInProgress) return;

    final currentState = state as CurrentFastingSessionInProgress;
    // Create a state copy to trigger UI updates on each tick
    final newState = currentState.copyWith();

    emit(newState);
  }

  void _onPreviewTimerTicked(
    _PreviewTimerTicked event,
    Emitter<CurrentFastingSessionState> emit,
  ) {
    if (state is! CurrentFastingSessionReady) return;

    // Emit a new CurrentFastingSessionReady state to trigger UI rebuild
    emit(const CurrentFastingSessionReady());
  }

  Future<void> _onUpdateActiveFastWindow(
    UpdateActiveFastWindow event,
    Emitter<CurrentFastingSessionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CurrentFastingSessionInProgress) return;

    // Only update if the window has actually changed
    if (currentState.session.window == event.window) return;

    try {
      final updatedSession = await _updateActiveFastWindow.call(event.window);
      if (updatedSession != null) {
        emit(CurrentFastingSessionInProgress(updatedSession, null));
      }
    } catch (e) {
      // On error, keep the current state unchanged
      // Could emit an error state if needed
    }
  }

  Future<void> _onUpdateActiveFastStartTime(
    UpdateActiveFastStartTime event,
    Emitter<CurrentFastingSessionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CurrentFastingSessionInProgress) return;

    // // Only update if the start time has actually changed
    // if (currentState.session.start == event.startTime) return;

    try {
      final updatedSession =
          await _updateActiveFastStartTime.call(event.startTime);
      if (updatedSession != null) {
        // Recalculate elapsed time and restart ticker
        final elapsed = DateTime.now().difference(updatedSession.start);
        _startTicker(startFrom: elapsed);
        emit(CurrentFastingSessionInProgress(updatedSession, null));
      }
    } catch (e) {
      print(e);
      // On error, keep the current state unchanged
      // Could emit an error state if needed
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    _settingsSubscription?.cancel();
    _stopPreviewTimer();
    return super.close();
  }
}
