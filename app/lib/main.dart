import 'package:flutter/material.dart';
import 'package:drift_app_database/drift_app_database.dart';
import 'package:fasting_app/app/app.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:local_notifications_service/local_notifications_service.dart';
import 'package:local_settings_api/shared_prefs_settings_api.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift_fasting_api/drift_fasting_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DriftAppDatabase();
  final sharedPrefs = await SharedPreferences.getInstance();

  final fastingApi = DriftFastingApi(db: db);
  final settingsApi = SharedPrefsSettingsApi(sharedPrefs: sharedPrefs);

  final notificationsService = await LocalNotificationsService()
    ..initialize();

  runApp(
    App(
      notificationsService: notificationsService,
      createFastingRepo: () => FastingRepository(
        fastingApi: fastingApi,
      ),
      createSettingsRepo: () => SettingsRepository(
        settingsApi: settingsApi,
      ),
    ),
  );
}
