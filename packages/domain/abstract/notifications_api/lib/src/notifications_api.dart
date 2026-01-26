import 'package:notifications_api/notifications_api.dart';

abstract class NotificationsApi {
  Future<Notification> createNotification({
    required String titleTKey,
    required String bodyTKey,
    required DateTime scheduledAt,
  });

  Future<Notification> getNotification(int id);

  Future<List<Notification>> getNotifications({
    DateTime? from,
    DateTime? to,
  });

  Future<void> deleteNotification(int id);
}
