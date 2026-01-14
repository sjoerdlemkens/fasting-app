import 'package:fasting_api/fasting_api.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_domain/fasting_domain.dart' as fasting_domain;

/// Repository for managing fasting sessions.
class FastingRepository {
  final FastingApi _fastingApi;

  const FastingRepository({
    required FastingApi fastingApi,
  }) : _fastingApi = fastingApi;

  /// Creates a new fasting session with the specified start time.
  Future<fasting_domain.FastingSession> createFastingSession({
    required DateTime started,
  }) async {
    final createdFast = await _fastingApi.createFastingSession(
      started: started,
    );

    final mappedFast = createdFast.toDomain();

    return mappedFast;
  }

  /// Retrieves fasting sessions with optional filtering.
  Future<List<fasting_domain.FastingSession>> getFastingSessions({
    bool? isActive,
    int? limit,
    DateTime? startAfter,
    DateTime? startBefore,
  }) async {
    final sessions = await _fastingApi.getFastingSessions(
      isActive: isActive,
      limit: limit,
      startAfter: startAfter,
      startBefore: startBefore,
    );

    return sessions.map((session) => session.toDomain()).toList();
  }

  /// Retrieves a fasting session by its ID.
  Future<fasting_domain.FastingSession> getFastingSessionById(int id) async {
    final session = await _fastingApi.getFastingSessionById(id);

    return session.toDomain();
  }

  /// Updates an existing fasting session with new values.
  Future<fasting_domain.FastingSession> updateFastingSession({
    required int id,
    DateTime? start,
    DateTime? end,
    FastingWindow? window,
  }) async {
    final updatedSession = await _fastingApi.updateFastingSession(
      id: id,
      start: start,
      end: end,
      window: window?.toInt(),
    );

    return updatedSession.toDomain();
  }

  /// Deletes a fasting session by its ID.
  Future<void> deleteFastingSession(int id) async {
    await _fastingApi.deleteFastingSession(id);
  }
}
