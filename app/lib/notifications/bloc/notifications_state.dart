part of 'notifications_bloc.dart';

@immutable
sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

final class NotificationCreated extends NotificationsState {
  final Notification notification;

  const NotificationCreated(this.notification);

  @override
  List<Object?> get props => [notification];
}

final class NotificationCancelled extends NotificationsState {
  final int notificationId;

  const NotificationCancelled(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}
