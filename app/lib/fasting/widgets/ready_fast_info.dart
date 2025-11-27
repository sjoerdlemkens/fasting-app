import 'package:fasting_app/fasting/fasting.dart';
import 'package:fasting_app/fasting/widgets/ready_fast_content.dart';
import 'package:flutter/material.dart';

class ReadyFastInfo extends StatelessWidget {
  final Duration duration;

  const ReadyFastInfo({
    super.key,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) => ProgressRing(
        progress: 0.0,
        child: ReadyFastContent(duration),
      );
}
