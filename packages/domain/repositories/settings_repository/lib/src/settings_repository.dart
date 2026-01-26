import 'dart:async';
import 'package:fasting_domain/fasting_domain.dart';
import 'package:settings_api/settings_api.dart';
import 'package:settings_repository/settings_repository.dart';

const _defaultFastingWindow = FastingWindow.eighteenSix;

class SettingsRepository {
  final SettingsApi _settingsApi;
  final _notificationsEnabledController = StreamController<bool>.broadcast();

  SettingsRepository({
    required SettingsApi settingsApi,
  }) : _settingsApi = settingsApi;

  Stream<bool> get notificationsEnabledStream =>
      _notificationsEnabledController.stream;

  Future<FastingWindow> getFastingWindow() async {
    final fastingType = _settingsApi.getFastingType();

    if (fastingType == null) return _defaultFastingWindow;

    final mappedFastingWindow = FastingWindowMappers.fromInt(fastingType);
    return mappedFastingWindow;
  }

  Future<void> setFastingWindow(FastingWindow fastingWindow) async {
    final fastingType = fastingWindow.toInt();
    await _settingsApi.setFastingType(fastingType);
  }

  /// Gets whether notifications are enabled.
  /// If not set, defaults to true.
  Future<bool> getNotificationsEnabled() async {
    final enabled = _settingsApi.getNotificationsEnabled();
    return enabled ?? true;
  }

  /// Sets whether notifications are enabled.
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _settingsApi.setNotificationsEnabled(enabled);
    _notificationsEnabledController.add(enabled);
  }

  void dispose() {
    _notificationsEnabledController.close();
  }
}
