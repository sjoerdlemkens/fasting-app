import 'package:flutter/material.dart';
import 'package:fasting_repository/fasting_repository.dart';

class CalendarDayWidget extends StatelessWidget {
  final DateTime date;
  final List<FastingSession> fastingSessions;
  final bool isToday;
  final bool isCurrentMonth;

  const CalendarDayWidget({
    super.key,
    required this.date,
    required this.fastingSessions,
    this.isToday = false,
    this.isCurrentMonth = true,
  });

  double get _averageProgress {
    if (fastingSessions.isEmpty) return 0.0;

    final totalProgress = fastingSessions
        .map((session) => session.progress)
        .reduce((a, b) => a + b);

    return (totalProgress / fastingSessions.length).clamp(0.0, 1.0);
  }

  Color get _progressColor {
    if (fastingSessions.isEmpty) return Colors.grey[300]!;

    final avgProgress = _averageProgress;
    if (avgProgress >= 1.0)
      return const Color(0xFF4CAF50); // Green for completed
    if (avgProgress >= 0.5)
      return const Color(0xFFFF8A65); // Orange for in progress
    return const Color(0xFFFFB74D); // Light orange for started
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isCurrentMonth
        ? (isToday ? Colors.white : Colors.black87)
        : Colors.grey[400];

    return Container(
      decoration: BoxDecoration(
        color: isToday ? Theme.of(context).primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Day number
          Positioned(
            top: 4,
            left: 4,
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: textColor,
              ),
            ),
          ),
          // Checkmark for fasted days
          if (fastingSessions.isNotEmpty)
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _progressColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
