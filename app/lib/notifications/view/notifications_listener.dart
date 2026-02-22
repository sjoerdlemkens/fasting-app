import 'dart:developer';

import 'package:fasting_app/app/app.dart';
import 'package:fasting_app/notifications/bloc/notifications_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _logger = Logger('NotificationsListener');

class NotificationsListener extends StatelessWidget {
  final Widget child;

  const NotificationsListener({
    super.key,
    required this.child,
  });

  void _onNotificationCreated(BuildContext context, NotificationCreated state) {
    final notification = state.notification;
    _logger.config(
      'NotificationCreated triggered in view[ID: ${notification.id}]',
    );

    final title = _translateNotificationTKey(context, notification.titleTKey);
    final body = _translateNotificationTKey(context, notification.bodyTKey);

    final notificationBloc = context.read<NotificationsBloc>();
    notificationBloc.add(ScheduleNotification(
      id: notification.id,
      title: title,
      body: body,
      scheduledAt: notification.scheduledAt,
    ));
  }

  String _translateNotificationTKey(BuildContext context, String tKey) {
    switch (tKey) {
      case 'fastCompletedNotificationTitle':
        return AppLocalizations.of(context)!.fastCompletedNotificationTitle;
      case 'fastCompletedNotificationBody':
        return AppLocalizations.of(context)!.fastCompletedNotificationBody;
      default:
        log('Translation key $tKey not implemented');
        return tKey;
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<NotificationsBloc, NotificationsState>(
        listener: (context, state) {
          if (state is NotificationCreated) {
            _onNotificationCreated(context, state);
          }
        },
        child: child,
      );
}
