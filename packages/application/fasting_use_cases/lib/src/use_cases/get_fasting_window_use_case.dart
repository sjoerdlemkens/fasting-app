import 'package:fasting_entities/fasting_entities.dart';
import 'package:settings_repository/settings_repository.dart';

class GetFastingWindowUseCase {
  final SettingsRepository _settingsRepo;

  GetFastingWindowUseCase({required SettingsRepository settingsRepo})
    : _settingsRepo = settingsRepo;

  Future<FastingWindow> call() async {
    final fastingWindow = await _settingsRepo.getFastingWindow();
    return fastingWindow ?? FastingWindow.eighteenSix;
  }
}
