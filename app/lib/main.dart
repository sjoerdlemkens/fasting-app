import 'package:flutter/material.dart';
import 'package:drift_app_database/drift_app_database.dart';
import 'package:drift_fasting_api/drift_fasting_api.dart';
import 'package:drift_notifications_api/drift_notifications_api.dart';
import 'package:fasting_app/app/app.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:local_notifications_service/local_notifications_service.dart';
import 'package:local_settings_api/shared_prefs_settings_api.dart';
import 'package:logging/logging.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.initialize(level: Level.CONFIG);

  final db = DriftAppDatabase();
  final sharedPrefs = await SharedPreferences.getInstance();

  final fastingApi = DriftFastingApi(db: db);
  final notificationsApi = DriftNotificationsApi(db: db);
  final settingsApi = SharedPrefsSettingsApi(sharedPrefs: sharedPrefs);

  final notificationsService = LocalNotificationsService();
  await notificationsService.initialize();

  runApp(
    App(
      notificationsService: notificationsService,
      createFastingRepo: () => FastingRepository(
        fastingApi: fastingApi,
      ),
      createSettingsRepo: () => SettingsRepository(
        settingsApi: settingsApi,
      ),
      createNotificationsRepo: () => NotificationsRepository(
        notificationsApi: notificationsApi,
      ),
    ),
  );
}
