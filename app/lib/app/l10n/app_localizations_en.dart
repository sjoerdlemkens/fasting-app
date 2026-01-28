// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get fastCompletedNotificationTitle => 'Fasting Complete';

  @override
  String get fastCompletedNotificationBody =>
      'You reached your goal. Great job!';

  @override
  String get notificationPermissionDeniedError =>
      'Notification permission denied. Please enable it in settings.';

  @override
  String get unknownError => 'An unknown error occurred.';
}
