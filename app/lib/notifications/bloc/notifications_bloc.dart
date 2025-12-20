import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notifications_service/notifications_service.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsService _notificationsService;

  NotificationsBloc({
    required NotificationsService notificationsService,
  })  : _notificationsService = notificationsService,
        super(NotificationsInitial()) {
    on<ScheduleNotification>(_onScheduleNotification);
    on<CancelNotification>(_onCancelNotification);
  }

  void _onScheduleNotification(
    ScheduleNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    final notificationId = DateTime.now().millisecondsSinceEpoch;

    final notification = Notification(
      id: notificationId,
      title: event.title,
      body: event.body,
      scheduledDate: event.scheduledDate,
    );

    await _notificationsService.scheduleNotification(notification);

    emit(NotificationScheduled(notificationId));
  }

  void _onCancelNotification(
    CancelNotification event,
    Emitter<NotificationsState> emit,
  ) =>
      emit(
        NotificationCancelled(
          event.notificationId,
        ),
      );
}
