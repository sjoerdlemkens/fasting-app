import 'package:flutter/material.dart';
import 'package:fasting_app/settings/settings.dart';

class SettingsLoadedView extends StatelessWidget {
  final SettingsLoaded state;

  const SettingsLoadedView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    final settings = state.settings;

    return ListView(
      children: [
        FastingWindowSetting(
          fastingWindow: settings.fastingWindow,
        ),
      ],
    );
  }
}
