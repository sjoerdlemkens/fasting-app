import 'package:settings_repository/settings_repository.dart';

class SetNotificationsEnabledUseCase {
  final SettingsRepository _settingsRepo;

  SetNotificationsEnabledUseCase({required SettingsRepository settingsRepo})
    : _settingsRepo = settingsRepo;

  Future<void> call(bool enabled) async {
    await _settingsRepo.setNotificationsEnabled(enabled);
  }
}
