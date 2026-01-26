import 'package:fasting_app/l10n/app_localizations.dart';
import 'package:fasting_app/notifications/bloc/notifications_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsListener extends StatelessWidget {
  final Widget child;

  const NotificationsListener({
    super.key,
    required this.child,
  });

  void _onNotificationCreated(BuildContext context, NotificationCreated state) {
    final notification = state.notification;

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

  // TODO: Improve this
  String _translateNotificationTKey(BuildContext context, String tKey) =>
      switch (tKey) {
        'fastingEndNotificationTitle' =>
          AppLocalizations.of(context)!.fastingEndNotificationTitle,
        'fastingEndNotificationBody' =>
          AppLocalizations.of(context)!.fastingEndNotificationBody,
        _ => throw UnimplementedError('Translation key $tKey not implemented'),
      };

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
