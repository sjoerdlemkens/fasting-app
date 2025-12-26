import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/current_fasting_session/utils/utils.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';

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
        const SizedBox(height: AppSpacing.sm),
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
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.gps_fixed,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: AppSpacing.xs),
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

