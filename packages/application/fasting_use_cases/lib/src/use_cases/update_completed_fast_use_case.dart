import 'package:fasting_repository/fasting_repository.dart';

class UpdateCompletedFastUseCase {
  final FastingRepository _fastingRepo;

  UpdateCompletedFastUseCase({required FastingRepository fastingRepo})
      : _fastingRepo = fastingRepo;

  Future<FastingSession?> call({
    required int fastId,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    // Validate that start time is not in the future
    final now = DateTime.now();
    if (startTime != null && startTime.isAfter(now)) {
      return null;
    }

    // Validate that end time is not in the future
    if (endTime != null && endTime.isAfter(now)) {
      return null;
    }

    // If both times are provided, validate that end is after start
    if (startTime != null && endTime != null && !endTime.isAfter(startTime)) {
      return null;
    }

    // Get the current session to validate against
    final currentSession = await _fastingRepo.getFastingSessionById(fastId);

    // Use provided times or keep existing ones
    final newStartTime = startTime ?? currentSession.start;
    final newEndTime = endTime ?? currentSession.end;

    // Final validation: end must be after start
    if (newEndTime != null && !newEndTime.isAfter(newStartTime)) {
      return null;
    }

    // Update the session
    final updatedSession = await _fastingRepo.updateFastingSession(
      id: fastId,
      start: startTime,
      end: endTime,
    );

    return updatedSession;
  }
}

