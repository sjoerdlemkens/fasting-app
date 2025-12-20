import 'package:fasting_repository/fasting_repository.dart';
import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/fasting.dart';
import 'package:fasting_app/history/history.dart';

class CompletedFastInfo extends StatelessWidget {
  final FastingSession session;

  const CompletedFastInfo(
    this.session, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => ProgressRing(
        progress: session.progress.clamp(0.0, 1.0),
        child: CompletedFastContent(
          duration: session.elapsed,
          targetHours: session.window?.duration.inHours,
          isGoalAchieved: session.isGoalAchieved,
        ),
      );
}

