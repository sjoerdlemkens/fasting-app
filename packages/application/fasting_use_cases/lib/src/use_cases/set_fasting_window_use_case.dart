import 'package:fasting_entities/fasting_entities.dart';
import 'package:settings_repository/settings_repository.dart';

class SetFastingWindowUseCase {
  final SettingsRepository _settingsRepo;

  SetFastingWindowUseCase({required SettingsRepository settingsRepo})
    : _settingsRepo = settingsRepo;

  Future<void> call(FastingWindow fastingWindow) async {
    await _settingsRepo.setFastingWindow(fastingWindow);
  }
}
