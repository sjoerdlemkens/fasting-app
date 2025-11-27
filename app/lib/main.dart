import 'package:flutter/material.dart';
import 'package:fasting_app/app/app.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:local_fasting_api/local_fasting_api.dart';
import 'package:local_settings_api/local_settings_api.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final fastingApi = LocalFastingApi();
  final settingsApi = LocalSettingsApi(
    sharedPrefs: await SharedPreferences.getInstance(),
  );

  runApp(
    App(
      createFastingRepo: () => FastingRepository(
        fastingApi: fastingApi,
      ),
      createSettingsRepo: () => SettingsRepository(
        settingsApi: settingsApi,
      ),
    ),
  );
}
