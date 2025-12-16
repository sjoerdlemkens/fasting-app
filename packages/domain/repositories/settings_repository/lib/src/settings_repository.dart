import 'package:settings_api/settings_api.dart';
import 'package:fasting_domain/fasting_domain.dart';
import 'package:settings_repository/settings_repository.dart';

const _defaultFastingWindow = FastingWindow.eighteenSix;

class SettingsRepository {
  final SettingsApi _settingsApi;

  const SettingsRepository({
    required SettingsApi settingsApi,
  }) : _settingsApi = settingsApi;

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
}
