import 'package:fasting_repository/fasting_repository.dart';

class UpdateActiveFastStartTimeUseCase {
  final FastingRepository _fastingRepo;

  UpdateActiveFastStartTimeUseCase({required FastingRepository fastingRepo})
    : _fastingRepo = fastingRepo;

  Future<FastingSession?> call(DateTime startTime) async {
    // Validate that the start time is not in the future
    final now = DateTime.now();
    if (startTime.isAfter(now)) {
      return null;
    }

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

    // Update the start time
    final updatedSession = await _fastingRepo.updateFastingSession(
      id: activeSession.id!,
      start: startTime,
    );

    return updatedSession;
  }
}
