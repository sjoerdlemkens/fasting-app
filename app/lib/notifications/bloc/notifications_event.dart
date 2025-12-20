part of 'notifications_bloc.dart';

@immutable
sealed class NotificationsEvent {
  const NotificationsEvent();
}

class ScheduleNotification extends NotificationsEvent {
  final String title;
  final String body;
  final DateTime scheduledDate;

  const ScheduleNotification({
    required this.title,
    required this.body,
    required this.scheduledDate,
  });
}

class CancelNotification extends NotificationsEvent {
  final int notificationId;

  const CancelNotification(this.notificationId);
}
