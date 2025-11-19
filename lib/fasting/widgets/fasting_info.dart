import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/fasting.dart';

class FastingInfo extends StatelessWidget {
  const FastingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return ProgressRing(
      progress: 0.58,
      child: FastingInfoContent(),
    );
  }
}
