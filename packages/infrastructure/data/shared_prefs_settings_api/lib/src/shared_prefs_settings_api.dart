import 'package:settings_api/settings_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsSettingsApi implements SettingsApi {
  final SharedPreferences _sharedPrefs;

  static const String _fastingTypeKey = 'fasting_type';
  static const String _notificationsEnabledKey = 'notifications_enabled';

  SharedPrefsSettingsApi({
    required SharedPreferences sharedPrefs,
  }) : _sharedPrefs = sharedPrefs;

  @override
  int? getFastingType() => _sharedPrefs.getInt(_fastingTypeKey);

  @override
  Future<void> setFastingType(int type) =>
      _sharedPrefs.setInt(_fastingTypeKey, type);

  @override
  bool? getNotificationsEnabled() =>
      _sharedPrefs.getBool(_notificationsEnabledKey);

  @override
  Future<void> setNotificationsEnabled(bool enabled) =>
      _sharedPrefs.setBool(_notificationsEnabledKey, enabled);
}
