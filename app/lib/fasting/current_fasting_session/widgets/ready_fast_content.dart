import 'package:flutter/material.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';

class ReadyFastContent extends StatelessWidget {
  final Duration duration;

  const ReadyFastContent(this.duration, {super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            "Not fasting",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
}

