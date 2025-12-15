import 'dart:async';
import 'package:fasting_use_cases/fasting_use_cases.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:fasting_app/fasting/fasting.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_repository/fasting_repository.dart'; // FastingWindow comes from here

part 'fasting_event.dart';
part 'fasting_state.dart';

class FastingBloc extends Bloc<FastingEvent, FastingState> {
  final StartFastUseCase _startFast;
  final EndFastUseCase _endFast;
  final GetActiveFastUseCase _getActiveFast;
  final UpdateActiveFastWindowUseCase _updateActiveFastWindow;
  final UpdateActiveFastStartTimeUseCase _updateActiveFastStartTime;

  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;
  StreamSubscription<SettingsState>? _settingsSubscription;
  Timer? _previewTimer;

  FastingBloc({
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
        super(FastingInitial()) {
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
    Emitter<FastingState> emit,
  ) async {
    emit(const FastingLoading());

    try {
      final activeFastingSession = await _getActiveFast.call();

      if (activeFastingSession != null) {
        final elapsed = DateTime.now().difference(activeFastingSession.start);
        _stopPreviewTimer();
        _startTicker(startFrom: elapsed);

        emit(FastingInProgress(activeFastingSession));
      } else {
        _startPreviewTimer();
        emit(const FastingInitial());
      }
    } catch (e) {
      // TODO:  Log the error
      _startPreviewTimer();
      emit(const FastingInitial());
    }
  }

  void _onFastStarted(FastStarted event, Emitter<FastingState> emit) async {
    final fastingSession = await _startFast.call();
    _stopPreviewTimer();
    _startTicker();

    emit(
      FastingInProgress(fastingSession),
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
      if (state is FastingInitial) {
        add(const _PreviewTimerTicked());
      }
    });
  }

  void _stopPreviewTimer() {
    _previewTimer?.cancel();
    _previewTimer = null;
  }

  void _onFastEnded(FastEnded event, Emitter<FastingState> emit) {
    final state = this.state;
    if (state is! FastingInProgress) return;

    final fastId = state.session.id!;
    _endFast.call(fastId);

    _tickerSubscription?.cancel();
    _startPreviewTimer();
    emit(FastingInitial());
  }

  void _onTimerTicked(_TimerTicked event, Emitter<FastingState> emit) {
    if (state is! FastingInProgress) return;

    final currentState = state as FastingInProgress;
    // Create a state copy to trigger UI updates on each tick
    final newState = currentState.copyWith();

    emit(newState);
  }

  void _onPreviewTimerTicked(
    _PreviewTimerTicked event,
    Emitter<FastingState> emit,
  ) {
    if (state is! FastingInitial) return;

    // Emit a new FastingInitial state to trigger UI rebuild
    emit(const FastingInitial());
  }

  Future<void> _onUpdateActiveFastWindow(
    UpdateActiveFastWindow event,
    Emitter<FastingState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FastingInProgress) return;

    // Only update if the window has actually changed
    if (currentState.session.window == event.window) return;

    try {
      final updatedSession = await _updateActiveFastWindow.call(event.window);
      if (updatedSession != null) {
        emit(FastingInProgress(updatedSession));
      }
    } catch (e) {
      // On error, keep the current state unchanged
      // Could emit an error state if needed
    }
  }

  Future<void> _onUpdateActiveFastStartTime(
    UpdateActiveFastStartTime event,
    Emitter<FastingState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FastingInProgress) return;

    // // Only update if the start time has actually changed
    // if (currentState.session.start == event.startTime) return;

    try {
      final updatedSession =
          await _updateActiveFastStartTime.call(event.startTime);
      if (updatedSession != null) {
        // Recalculate elapsed time and restart ticker
        final elapsed = DateTime.now().difference(updatedSession.start);
        _startTicker(startFrom: elapsed);
        emit(FastingInProgress(updatedSession));
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
