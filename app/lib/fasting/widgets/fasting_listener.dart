import 'package:fasting_app/fasting/bloc/fasting_bloc.dart';
import 'package:fasting_app/l10n/app_localizations.dart';
import 'package:fasting_app/notifications/bloc/notifications_bloc.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';

class FastingListener extends StatelessWidget {
  final Widget child;

  const FastingListener({
    super.key,
    required this.child,
  });

  void _onFastStarted(BuildContext context, FastingInProgress state) {
    final notificationsBloc = context.read<NotificationsBloc>();

    notificationsBloc.add(
      ScheduleNotification(
        title: AppLocalizations.of(context)!.fastingEndNotificationTitle,
        body: AppLocalizations.of(context)!.fastingEndNotificationBody,
        scheduledDate: state.session.endsOn,
      ),
    );
  }

  void _onFastEnded(BuildContext context, FastingState state) {
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
          BlocListener<FastingBloc, FastingState>(
            listenWhen: (prevState, currState) =>
                prevState is FastingReady && currState is FastingInProgress,
            listener: (context, state) => _onFastStarted(
              context,
              state as FastingInProgress,
            ),
          ),
          BlocListener<FastingBloc, FastingState>(
            listenWhen: (prevState, currState) =>
                prevState is FastingInProgress && currState is FastingReady,
            listener: (context, state) => _onFastEnded(
              context,
              state,
            ),
          ),
        ],
        child: child,
      );
}
