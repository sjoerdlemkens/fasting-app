import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/settings/settings.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Widget _buildLoading() => Center(
        child: CircularProgressIndicator(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) => switch (state) {
        SettingsInitial() || SettingsLoading() => _buildLoading(),
        SettingsLoaded() =>  SettingsLoadedView(state),
      },
    );
  }
}
