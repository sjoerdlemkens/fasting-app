import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double progress;
  final Widget child;
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color? backgroundColor;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 280,
    this.strokeWidth = 20,
    this.progressColor = const Color(0xFFFF8A65),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.grey[200]!;

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
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          // Center content
          child,
        ],
      ),
    );
  }
}
