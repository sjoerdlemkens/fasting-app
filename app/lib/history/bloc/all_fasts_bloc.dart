import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:meta/meta.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';

part 'all_fasts_event.dart';
part 'all_fasts_state.dart';

class AllFastsBloc extends Bloc<AllFastsEvent, AllFastsState> {
  final GetMonthlyHistoryUseCase _getMonthlyHistory;

  AllFastsBloc({
    required GetMonthlyHistoryUseCase getMonthlyHistory,
  })  : _getMonthlyHistory = getMonthlyHistory,
        super(const AllFastsInitial()) {
    on<LoadAllFastsMonth>(_onLoadAllFastsMonth);
    on<ChangeAllFastsMonth>(_onChangeAllFastsMonth);
  }

  Future<void> _onLoadAllFastsMonth(
    LoadAllFastsMonth event,
    Emitter<AllFastsState> emit,
  ) async {
    emit(const AllFastsLoading());

    try {
      final month = event.month;
      final sessionsByDay = await _getMonthlyHistory(month);

      // Flatten the map into a single list of sessions, sorted by start time (newest first)
      final allSessions = <FastingSession>[];
      for (final sessions in sessionsByDay.values) {
        allSessions.addAll(sessions);
      }
      allSessions.sort((a, b) => b.start.compareTo(a.start));

      emit(AllFastsLoaded(
        currentMonth: month,
        fastingSessions: allSessions,
      ));
    } catch (error) {
      emit(AllFastsError(error.toString()));
    }
  }

  Future<void> _onChangeAllFastsMonth(
    ChangeAllFastsMonth event,
    Emitter<AllFastsState> emit,
  ) async {
    add(LoadAllFastsMonth(event.month));
  }
}


