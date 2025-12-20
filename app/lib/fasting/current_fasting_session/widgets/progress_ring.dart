import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double progress;
  final Widget child;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 256,
    this.strokeWidth = 16,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? const Color(0xFFE2E8F0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              backgroundColor: bgColor,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.transparent),
            ),
          ),
          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.transparent,
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          // Center content
          child,
        ],
      ),
    );
  }
}

