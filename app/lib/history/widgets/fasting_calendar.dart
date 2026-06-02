import 'package:flutter/material.dart';
import 'package:fasting_app/misc/misc.dart';
import 'package:fasting_repository/fasting_repository.dart';

/// A calendar widget specifically designed for displaying fasting history.
///
/// This widget builds on top of [BaseCalendar] and provides fasting-specific
/// functionality by showing [CalendarDayWidget] for each day with fasting sessions.
class FastingCalendar extends StatelessWidget {
  /// The month to display (any date within the desired month)
  final DateTime currentMonth;

  /// Map of fasting sessions grouped by day
  final Map<DateTime, List<FastingSession>> fastingSessionsByDay;

  /// Active fasting session (if any)
  final FastingSession? activeFast;

  /// Callback when the previous month button is pressed
  final VoidCallback? onPreviousMonth;

  /// Callback when the next month button is pressed
  final VoidCallback? onNextMonth;

  const FastingCalendar({
    super.key,
    required this.currentMonth,
    required this.fastingSessionsByDay,
    this.activeFast,
    this.onPreviousMonth,
    this.onNextMonth,
  });

  /// Normalizes a date to remove time components for consistent map lookups
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    return BaseCalendar(
      currentMonth: currentMonth,
      onPreviousMonth: onPreviousMonth,
      onNextMonth: onNextMonth,
      weekdayLabels: const ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
      padding: EdgeInsets.zero, // Remove padding since it's in a card
      dayBuilder: (date, isCurrentMonth, isToday) {
        final normalizedDate = _normalizeDate(date);
        final sessions = fastingSessionsByDay[normalizedDate] ?? [];

        // If today and there's an active fast, include it
        FastingSession? todayActiveFast;
        if (isToday && activeFast != null) {
          final today = DateTime.now();
          final activeFastStart = activeFast!.start;
          final activeFastDay = DateTime(
            activeFastStart.year,
            activeFastStart.month,
            activeFastStart.day,
          );
          final todayDay = DateTime(today.year, today.month, today.day);
          if (activeFastDay == todayDay) {
            todayActiveFast = activeFast;
          }
        }

        return CalendarDayWidget(
          date: date,
          fastingSessions: sessions,
          activeFast: todayActiveFast,
          isToday: isToday,
          isCurrentMonth: isCurrentMonth,
        );
      },
    );
  }
}
