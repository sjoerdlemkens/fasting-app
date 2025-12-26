import 'package:fasting_app/fasting/current_fasting_session/current_fasting_session.dart';
import 'package:fasting_app/l10n/app_localizations.dart';
import 'package:fasting_app/notifications/bloc/notifications_bloc.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';

class FastingListener extends StatelessWidget {
  final Widget child;

  const FastingListener({
    super.key,
    required this.child,
  });

  void _onFastStarted(
      BuildContext context, CurrentFastingSessionInProgress state) {
    final settingsState = context.read<SettingsBloc>().state;

    if (settingsState is SettingsLoaded &&
        settingsState.settings.notificationsEnabled) {
      final notificationsBloc = context.read<NotificationsBloc>();

      notificationsBloc.add(
        ScheduleNotification(
          title: AppLocalizations.of(context)!.fastingEndNotificationTitle,
          body: AppLocalizations.of(context)!.fastingEndNotificationBody,
          scheduledDate: state.session.endsOn,
        ),
      );
    }
  }

  void _onFastEnded(BuildContext context, CurrentFastingSessionState state) {
    // Notificatnion id should be addeded to fasting metadata

    // IF notificaiton is scheduled, cancel it

    // final notificationsBloc = context.read<NotificationsBloc>();
    // notificationsBloc.add(
    //   CancelNotification(
    //     state.session.id!,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) => MultiBlocListener(
        listeners: [
          BlocListener<CurrentFastingSessionBloc, CurrentFastingSessionState>(
            listenWhen: (prevState, currState) =>
                prevState is CurrentFastingSessionReady &&
                currState is CurrentFastingSessionInProgress,
            listener: (context, state) => _onFastStarted(
              context,
              state as CurrentFastingSessionInProgress,
            ),
          ),
          BlocListener<CurrentFastingSessionBloc, CurrentFastingSessionState>(
            listenWhen: (prevState, currState) =>
                prevState is CurrentFastingSessionInProgress &&
                currState is CurrentFastingSessionReady,
            listener: (context, state) => _onFastEnded(
              context,
              state,
            ),
          ),
        ],
        child: child,
      );
}
