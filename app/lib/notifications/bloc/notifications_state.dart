part of 'notifications_bloc.dart';

@immutable
sealed class NotificationsState {
  const NotificationsState();
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

final class NotificationCreated extends NotificationsState {
  final Notification notification;

  const NotificationCreated(this.notification);
}

final class NotificationCancelled extends NotificationsState {
  final int notificationId;

  const NotificationCancelled(this.notificationId);
}
