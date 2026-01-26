import 'models/notification.dart';

abstract class NotificationsService {
  Future<void> scheduleNotification(Notification notification);

  Future<void> cancelNotification(int id);

  void cancelAllNotifications();
}
