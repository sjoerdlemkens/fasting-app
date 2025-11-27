import 'package:fasting_repository/fasting_repository.dart';

class GetMonthlyHistoryUseCase {
  final FastingRepository _fastingRepository;

  GetMonthlyHistoryUseCase({required FastingRepository fastingRepository})
    : _fastingRepository = fastingRepository;

  /// Gets fasting sessions for a given month and returns them grouped by day
  Future<Map<DateTime, List<FastingSession>>> call(DateTime month) async {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

    // Get fasting sessions for the entire month
    final sessions = await _fastingRepository.getFastingSessions(
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

    return sessionsByDay;
  }
}
