import 'package:fasting_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/misc/view/loading_view.dart';
import 'package:fasting_app/settings/settings.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  void _onSettingsUpdateError(BuildContext context, SettingsUpdateError state) {
    final errorMessage = switch (state.error) {
      SettingsError.notificationPermissionDenied =>
        AppLocalizations.of(context)!.notificationPermissionDeniedError,
      SettingsError.unknown => AppLocalizations.of(context)!.unknownError,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsUpdateError) {
            _onSettingsUpdateError(context, state);
          }
        },
        builder: (context, state) => switch (state) {
          SettingsInitial() || SettingsLoading() => LoadingView(),
          SettingsLoaded() => SettingsLoadedView(state),
        },
      );
}
