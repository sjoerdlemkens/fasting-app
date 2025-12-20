part of 'notifications_bloc.dart';

@immutable
sealed class NotificationsState {
  const NotificationsState();
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

final class NotificationScheduled extends NotificationsState {
  final int notificationId;

  const NotificationScheduled(this.notificationId);
}

final class NotificationCancelled extends NotificationsState {
  final int notificationId;

  const NotificationCancelled(this.notificationId);
}
