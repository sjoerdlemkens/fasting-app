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

  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;
  StreamSubscription<SettingsState>? _settingsSubscription;

  FastingBloc({
    required StartFastUseCase startFast,
    required EndFastUseCase endFast,
    required GetActiveFastUseCase getActiveFast,
    required UpdateActiveFastWindowUseCase updateActiveFastWindow,
    required SettingsBloc settingsBloc,
    Ticker ticker = const Ticker(),
  })  : _startFast = startFast,
        _endFast = endFast,
        _getActiveFast = getActiveFast,
        _updateActiveFastWindow = updateActiveFastWindow,
        _ticker = ticker,
        super(FastingInitial()) {
    on<LoadActiveFast>(_onLoadActiveFast);
    on<FastStarted>(_onFastStarted);
    on<FastEnded>(_onFastEnded);
    on<_TimerTicked>(_onTimerTicked);
    on<UpdateActiveFastWindow>(_onUpdateActiveFastWindow);

    // Listen to SettingsBloc changes
    _settingsSubscription = settingsBloc.stream.listen((settingsState) {
      if (settingsState is SettingsLoaded) {
        add(UpdateActiveFastWindow(settingsState.settings.fastingWindow));
      }
    });
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
        _startTicker(startFrom: elapsed);

        emit(FastingInProgress(activeFastingSession));
      } else {
        emit(const FastingInitial());
      }
    } catch (e) {
      // TODO:  Log the error
      emit(const FastingInitial());
    }
  }

  void _onFastStarted(FastStarted event, Emitter<FastingState> emit) async {
    final fastingSession = await _startFast.call();
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

  void _onFastEnded(FastEnded event, Emitter<FastingState> emit) {
    final state = this.state;
    if (state is! FastingInProgress) return;

    final fastId = state.session.id!;
    _endFast.call(fastId);

    _tickerSubscription?.cancel();
    emit(FastingInitial());
  }

  void _onTimerTicked(_TimerTicked event, Emitter<FastingState> emit) {
    if (state is! FastingInProgress) return;

    final currentState = state as FastingInProgress;
    // Create a state copy to trigger UI updates on each tick
    final newState = currentState.copyWith();

    emit(newState);
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

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    _settingsSubscription?.cancel();
    return super.close();
  }
}
