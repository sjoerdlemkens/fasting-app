part of 'notifications_bloc.dart';

@immutable
sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
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

  @override
  List<Object> get props => [title, body, scheduledDate];
}

class CancelNotification extends NotificationsEvent {
  final int notificationId;

  const CancelNotification(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}
