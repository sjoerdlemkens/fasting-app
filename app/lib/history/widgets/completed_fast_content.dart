import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/fasting.dart';

class CompletedFastContent extends StatelessWidget {
  final Duration duration;
  final int? targetHours;
  final bool isGoalAchieved;

  const CompletedFastContent({
    super.key,
    required this.duration,
    this.targetHours,
    required this.isGoalAchieved,
  });

  @override
  Widget build(BuildContext context) {
    final durationFormatted = TimeFormatter.formatDuration(duration);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "TOTAL DURATION",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          durationFormatted,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Color(0xFF0F172A), // slate-900
          ),
        ),
        if (targetHours != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isGoalAchieved ? Icons.check_circle : Icons.gps_fixed,
                size: 16,
                color: isGoalAchieved
                    ? const Color(0xFF4DB6AC)
                    : Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                isGoalAchieved
                    ? "Goal achieved: $targetHours hours"
                    : "Target: $targetHours hours",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isGoalAchieved
                      ? const Color(0xFF4DB6AC)
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

