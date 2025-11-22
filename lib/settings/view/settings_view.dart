import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/misc/view/loading_view.dart';
import 'package:fasting_app/settings/settings.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) => switch (state) {
        SettingsInitial() || SettingsLoading() => LoadingView(),
        SettingsLoaded() => SettingsLoadedView(state),
      },
    );
  }
}
