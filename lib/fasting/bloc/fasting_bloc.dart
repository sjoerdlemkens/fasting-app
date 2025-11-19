import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_app/fasting/fasting.dart';

part 'fasting_event.dart';
part 'fasting_state.dart';

class FastingBloc extends Bloc<FastingEvent, FastingState> {
  final FastingRepository _fastingRepo;

  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  FastingBloc({
    required FastingRepository fastingRepo,
    Ticker ticker = const Ticker(),
  })  : _fastingRepo = fastingRepo,
        _ticker = ticker,
        super(FastingInitial()) {
    on<FastStarted>(_onFastStarted);
    on<FastEnded>(_onFastEnded);
    on<_TimerTicked>(_onTimerTicked);
  }

  void _onFastStarted(FastStarted event, Emitter<FastingState> emit) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen(
          (seconds) => add(
            _TimerTicked(duration: Duration(seconds: seconds)),
          ),
        );

    emit(const FastingInProgress(elapsed: Duration.zero));
  }

  void _onFastEnded(FastEnded event, Emitter<FastingState> emit) {
    // TODO: Create logic to save fast data using _fastingRepo
    _tickerSubscription?.cancel();
    emit(FastingInitial());
  }

  void _onTimerTicked(_TimerTicked event, Emitter<FastingState> emit) {
    emit(FastingInProgress(elapsed: event.duration));
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
