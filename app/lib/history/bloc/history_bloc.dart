import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:meta/meta.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final FastingRepository _fastingRepo;

  HistoryBloc({
    required FastingRepository fastingRepo,
  })  : _fastingRepo = fastingRepo,
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

      // Get monthly history grouped by day
      final firstDayOfMonth = DateTime(month.year, month.month, 1);
      final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

      final sessions = await _fastingRepo.getFastingSessions(
        startAfter: firstDayOfMonth.subtract(const Duration(days: 1)),
        startBefore: lastDayOfMonth.add(const Duration(days: 1)),
        isActive: false, // Only get completed sessions for history
      );

      // Group sessions by day
      final sessionsByDay = <DateTime, List<FastingSession>>{};
      for (final session in sessions) {
        final day = DateTime(
          session.start.year,
          session.start.month,
          session.start.day,
        );
        sessionsByDay.putIfAbsent(day, () => []).add(session);
      }

      // Get recent fasts (limit: 3, isActive: false)
      final lastFasts = await _fastingRepo.getFastingSessions(
        isActive: false,
        limit: 3,
      );

      // Get active fast (isActive: true, limit: 1)
      final activeSessions = await _fastingRepo.getFastingSessions(
        limit: 1,
        isActive: true,
      );
      final activeFast = activeSessions.firstOrNull;

      emit(HistoryLoaded(
        currentMonth: month,
        fastingSessionsByDay: sessionsByDay,
        lastFasts: lastFasts,
        activeFast: activeFast,
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
