abstract class NotificationsService {
  void scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  });

  void cancelNotification(int id);
}
