import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/fasting.dart';

class ActiveFastContent extends StatelessWidget {
  final Duration elapsed;
  final int? targetHours;

  const ActiveFastContent({
    super.key,
    required this.elapsed,
    this.targetHours,
  });

  @override
  Widget build(BuildContext context) {
    final elapsedFormatted = TimeFormatter.formatDuration(elapsed);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "TIME ELAPSED",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          elapsedFormatted,
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
                Icons.gps_fixed,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                "Target: $targetHours hours",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
