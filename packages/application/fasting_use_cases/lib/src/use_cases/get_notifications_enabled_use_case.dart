import 'package:settings_repository/settings_repository.dart';

class GetNotificationsEnabledUseCase {
  final SettingsRepository _settingsRepo;

  GetNotificationsEnabledUseCase({required SettingsRepository settingsRepo})
    : _settingsRepo = settingsRepo;

  Future<bool> call() async {
    return await _settingsRepo.getNotificationsEnabled();
  }
}
