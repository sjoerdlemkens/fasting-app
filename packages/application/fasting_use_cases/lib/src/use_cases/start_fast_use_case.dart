import 'package:fasting_repository/fasting_repository.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:notifications_service/notifications_service.dart';

class StartFastUseCase {
  final FastingRepository _fastingRepo;
  final SettingsRepository _settingsRepo;
  final NotificationsService _notificationsService;

  StartFastUseCase({
    required FastingRepository fastingRepo,
    required SettingsRepository settingsRepo,
    required NotificationsService notificationsService,
  }) : _fastingRepo = fastingRepo,
       _settingsRepo = settingsRepo,
       _notificationsService = notificationsService;

  Future<FastingSession> call() async {
    final fastingWindow = await _settingsRepo.getFastingWindow();
    final fastingSession = await _fastingRepo.createFastingSession(
      started: DateTime.now(),
    );

    // Copy stored fasting session with window from settings
    final composedFastingSession = fastingSession.copyWith(
      window: fastingWindow,
    );

    // Schedule notification when fast ends
    await _notificationsService.scheduleNotification(
      id: composedFastingSession.id!,
      title: 'Fast Complete',
      body: 'Your fasting period has ended. Great job!',
      scheduledDate: composedFastingSession.endsOn,
    );

    return composedFastingSession;
  }
}
