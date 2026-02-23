import 'package:logging/logging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifications_service/notifications_service.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

final _logger = Logger('LocalNotificationsService');

class LocalNotificationsService implements NotificationsService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize the notifications service. Must be called before using.
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezones
    tz_data.initializeTimeZones();

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(iOS: iosSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
    _logger.config('LocalNotificationsService initialized successfully');
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap if needed
    _logger.info('Notification tapped: ${response.id}');
  }

  @override
  Future<void> scheduleNotification(Notification notification) async {
    if (!_initialized) {
      throw StateError(
        'LocalNotificationsService must be initialized before use. '
        'Call initialize() first.',
      );
    }

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(iOS: iosDetails);

    final tzScheduledDate = tz.TZDateTime.from(
      notification.scheduledAt,
      tz.local,
    );

    await _notifications.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tzScheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    _logger.config(
      'Notification [ID: ${notification.id}] scheduled successfully',
    );
  }

  @override
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    _logger.config('Notification [ID: $id] cancelled successfully');
  }

  /// Cancel all notifications
  @override
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    _logger.config('All notifications cancelled successfully');
  }
}
