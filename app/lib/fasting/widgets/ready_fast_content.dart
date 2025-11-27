import 'package:fasting_app/fasting/utils/time_formatter.dart';
import 'package:flutter/material.dart';

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
          const SizedBox(height: 16),
          Text(
            "Tap to begin",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            TimeFormatter.formatDuration(duration),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
        ],
      );
}
