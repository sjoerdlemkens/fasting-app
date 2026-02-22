import 'dart:async';
import 'package:logging/logging.dart';
import 'package:notifications_api/notifications_api.dart';

final _logger = Logger('NotificationsRepository');

class NotificationsRepository {
  final NotificationsApi _notificationsApi;

  final _createdNotificationsController = StreamController<Notification>();
  final _deletedNotificationsController = StreamController<int>();

  NotificationsRepository({required NotificationsApi notificationsApi})
    : _notificationsApi = notificationsApi;

  Stream<Notification> get createdNotificationsStream =>
      _createdNotificationsController.stream;

  Stream<int> get deletedNotificationsStream =>
      _deletedNotificationsController.stream;

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

    _logger.info('Created notification: ${notification.id}');
    return notification;
  }

  Future<Notification> getNotification(int id) =>
      _notificationsApi.getNotification(id);

  Future<List<Notification>> getNotifications({DateTime? from, DateTime? to}) =>
      _notificationsApi.getNotifications(from: from, to: to);

  Future<void> deleteNotification(int id) async {
    try {
      await _notificationsApi.deleteNotification(id);

      _deletedNotificationsController.add(id);

      _logger.info('Deleted notification: $id');
    } catch (e) {
      _logger.severe('Error deleting notification with ID $id: $e');
    }
  }

  void dispose() {
    _createdNotificationsController.close();
    _deletedNotificationsController.close();
  }
}
