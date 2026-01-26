import 'dart:async';
import 'package:notifications_api/notifications_api.dart';

class NotificationsRepository {
  final NotificationsApi _notificationsApi;
  final _createdNotificationsController =
      StreamController<Notification>.broadcast();

  NotificationsRepository({required NotificationsApi notificationsApi})
    : _notificationsApi = notificationsApi;

  Stream<Notification> get createdNotificationsStream =>
      _createdNotificationsController.stream;

  Future<Notification> createNotification({
    required String titleTKey,
    required String bodyTKey,
    required DateTime scheduledAt,
  }) async {
    final notification = await _notificationsApi.createNotification(
      titleTKey: titleTKey,
      bodyTKey: bodyTKey,
      scheduledAt: scheduledAt,
    );

    _createdNotificationsController.add(notification);

    return notification;
  }

  Future<Notification> getNotification(int id) =>
      _notificationsApi.getNotification(id);

  Future<List<Notification>> getNotifications({DateTime? from, DateTime? to}) =>
      _notificationsApi.getNotifications(from: from, to: to);

  Future<void> deleteNotification(int id) =>
      _notificationsApi.deleteNotification(id);

  void dispose() {
    _createdNotificationsController.close();
  }
}
