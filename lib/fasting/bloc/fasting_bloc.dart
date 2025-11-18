import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:fasting_repository/fasting_repository.dart';

part 'fasting_event.dart';
part 'fasting_state.dart';

class FastingBloc extends Bloc<FastingEvent, FastingState> {
  final FastingRepository _fastingRepo;

  FastingBloc({
    required FastingRepository fastingRepo,
  })  : _fastingRepo = fastingRepo,
        super(FastingInitial()) {
    on<FastStarted>(_onFastStarted);
    on<FastEnded>(_onFastEnded);
  }

  void _onFastStarted(FastStarted event, Emitter<FastingState> emit) {
    emit(FastingInProgress());
  }

  void _onFastEnded(FastEnded event, Emitter<FastingState> emit) {
    // TODO: Create logic to save fast data using _fastingRepo

    emit(FastingInitial());
  }
}
