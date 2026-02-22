import 'dart:async';
import 'package:settings_api/settings_api.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:fasting_repository/fasting_repository.dart' show FastingWindow;

const _defaultFastingWindow = FastingWindow.eighteenSix;

class SettingsRepository {
  final SettingsApi _settingsApi;
  final _notificationsEnabledController = StreamController<bool>.broadcast();
  final _fastingWindowController = StreamController<FastingWindow>.broadcast();

  SettingsRepository({
    required SettingsApi settingsApi,
  }) : _settingsApi = settingsApi;

  Stream<bool> get notificationsEnabledStream =>
      _notificationsEnabledController.stream;

  Stream<FastingWindow> get fastingWindowStream =>
      _fastingWindowController.stream;

  Future<FastingWindow> getFastingWindow() async {
    final fastingType = _settingsApi.getFastingType();

    if (fastingType == null) return _defaultFastingWindow;

    final mappedFastingWindow = FastingWindowMappers.fromInt(fastingType);
    return mappedFastingWindow;
  }

  Future<void> setFastingWindow(FastingWindow fastingWindow) async {
    final fastingType = fastingWindow.toInt();
    await _settingsApi.setFastingType(fastingType);

    _fastingWindowController.add(fastingWindow);
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
