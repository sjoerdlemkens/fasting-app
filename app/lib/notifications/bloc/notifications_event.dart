part of 'notifications_bloc.dart';

@immutable
sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

final class ScheduleNotification extends NotificationsEvent {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledAt;

  const ScheduleNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledAt,
  });

  @override
  List<Object> get props => [id, title, body, scheduledAt];
}

final class NotificationsCleanUpRequested extends NotificationsEvent {
  const NotificationsCleanUpRequested();

  @override
  List<Object> get props => [];
}

final class _NotificationCreated extends NotificationsEvent {
  final Notification notification;

  const _NotificationCreated(this.notification);

  @override
  List<Object> get props => [notification];
}

final class _NotificationDeleted extends NotificationsEvent {
  final int notificationId;

  const _NotificationDeleted(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

final class _NotificationsEnabledChanged extends NotificationsEvent {
  final bool enabled;

  const _NotificationsEnabledChanged(this.enabled);

  @override
  List<Object> get props => [enabled];
}
