import 'package:notifications_service/notifications_service.dart';

class LocalNotificationsService implements NotificationsService {
  @override
  void scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) {
    throw UnimplementedError();
  }

  @override
  void cancelNotification(int id) {
    throw UnimplementedError();
  }
}
