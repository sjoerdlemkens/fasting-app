import 'package:fasting_repository/fasting_repository.dart';
import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/fasting.dart';

class ActiveFastInfo extends StatelessWidget {
  final FastingSession session;

  const ActiveFastInfo(
    this.session, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => ProgressRing(
        progress: session.progress,
        child: ActiveFastContent(
          elapsed: session.elapsed,
          targetHours: session.window?.duration.inHours,
        ),
      );
}
