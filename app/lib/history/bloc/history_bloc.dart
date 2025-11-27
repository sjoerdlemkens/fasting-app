import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetMonthlyHistoryUseCase _getMonthlyHistory;

  HistoryBloc({
    required GetMonthlyHistoryUseCase getMonthlyHistory,
  })  : _getMonthlyHistory = getMonthlyHistory,
        super(const HistoryInitial()) {
    on<LoadHistoryMonth>(_onLoadHistoryMonth);
    on<ChangeMonth>(_onChangeMonth);
  }

  Future<void> _onLoadHistoryMonth(
    LoadHistoryMonth event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());

    try {
      final month = event.month;
      final sessionsByDay = await _getMonthlyHistory(month);

      emit(HistoryLoaded(
        currentMonth: month,
        fastingSessionsByDay: sessionsByDay,
      ));
    } catch (error) {
      emit(HistoryError(error.toString()));
    }
  }

  Future<void> _onChangeMonth(
    ChangeMonth event,
    Emitter<HistoryState> emit,
  ) async {
    add(LoadHistoryMonth(event.month));
  }
}
