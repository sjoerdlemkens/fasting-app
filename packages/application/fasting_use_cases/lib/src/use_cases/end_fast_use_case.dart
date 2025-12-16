import 'package:fasting_repository/fasting_repository.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:notifications_service/notifications_service.dart';

class EndFastUseCase {
  final FastingRepository _fastingRepo;
  final SettingsRepository _settingsRepo;
  final NotificationsService _notificationsService;

  EndFastUseCase({
    required FastingRepository fastingRepo,
    required SettingsRepository settingsRepo,
    required NotificationsService notificationsService,
  }) : _fastingRepo = fastingRepo,
       _settingsRepo = settingsRepo,
       _notificationsService = notificationsService;

  Future<FastingSession?> call(int fastId) async {
    final fastingWindow = await _settingsRepo.getFastingWindow();
    final updatedFastingSession = await _fastingRepo.updateFastingSession(
      id: fastId,
      end: DateTime.now(),
      window: fastingWindow,
    );

    await _notificationsService.cancelNotification(fastId);

    return updatedFastingSession;
  }
}
