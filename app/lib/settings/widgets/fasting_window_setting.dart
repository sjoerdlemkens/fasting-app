import 'package:flutter/material.dart';
import 'package:fasting_app/settings/bloc/settings_bloc.dart';
import 'package:fasting_app/settings/extensions/fasting_window_extensions.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FastingWindowSetting extends StatelessWidget {
  final FastingWindow fastingWindow;

  const FastingWindowSetting({
    super.key,
    required this.fastingWindow,
  });

  void _onFastingWindowChanged(BuildContext context, FastingWindow? window) {
    if (window != null) {
      final settingsBloc = context.read<SettingsBloc>();
      settingsBloc.add(UpdateFastingWindow(window));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Fasting Window'),
      trailing: DropdownButton<FastingWindow>(
        value: fastingWindow,
        onChanged: (window) => _onFastingWindowChanged(context, window),
        items: FastingWindow.values
            .map(
              (window) => DropdownMenuItem<FastingWindow>(
                value: window,
                child: Text(window.displayName),
              ),
            )
            .toList(),
      ),
    );
  }
}
