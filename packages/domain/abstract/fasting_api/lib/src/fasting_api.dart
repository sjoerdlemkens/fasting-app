import 'package:fasting_api/fasting_api.dart';

abstract class FastingApi {
  /// Creates a new fasting session with the specified start time.
  Future<FastingSession> createFastingSession({required DateTime started});

  /// Retrieves a fasting session by its ID.
  Future<FastingSession> getFastingSessionById(int id);

  /// Retrieves fasting sessions with optional filtering.
  Future<List<FastingSession>> getFastingSessions({
    bool? isActive,
    int? limit,
    DateTime? startAfter,
    DateTime? startBefore,
  });

  /// Updates an existing fasting session with new values.
  Future<FastingSession> updateFastingSession({
    required int id,
    DateTime? start,
    DateTime? end,
    int? window,
  });

  /// Deletes a fasting session by its ID.
  Future<void> deleteFastingSession(int id);

}
