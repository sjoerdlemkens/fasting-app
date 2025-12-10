import 'package:fasting_repository/fasting_repository.dart';

class UpdateActiveFastWindowUseCase {
  final FastingRepository _fastingRepo;

  UpdateActiveFastWindowUseCase({
    required FastingRepository fastingRepo,
  }) : _fastingRepo = fastingRepo;

  Future<FastingSession?> call(FastingWindow window) async {
    // Get the active fast
    final activeSessions = await _fastingRepo.getFastingSessions(
      isActive: true,
      limit: 1,
    );

    if (activeSessions.isEmpty) {
      return null;
    }

    final activeSession = activeSessions.first;
    if (activeSession.id == null) {
      return null;
    }

    // Update the window
    final updatedSession = await _fastingRepo.updateFastingSession(
      id: activeSession.id!,
      window: window,
    );

    return updatedSession;
  }
}


