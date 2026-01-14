import 'package:drift/drift.dart';
import 'package:drift_app_database/drift_app_database.dart';
import 'package:fasting_api/fasting_api.dart' as api;

class DriftFastingApi implements api.FastingApi {
  final DriftAppDatabase _db;

  DriftFastingApi({required DriftAppDatabase db}) : _db = db;

  @override
  Future<api.FastingSession> createFastingSession({
    required DateTime started,
  }) async {
    final id = await _db
        .into(_db.fastingSessions)
        .insert(FastingSessionsCompanion.insert(start: started));

    final createdFast = await getFastingSessionById(id);

    return createdFast;
  }

  @override
  Future<api.FastingSession> getFastingSessionById(int id) async {
    final fastingSession = await (_db.select(
      _db.fastingSessions,
    )..where((table) => table.id.equals(id))).getSingleOrNull();

    if (fastingSession == null) {
      throw Exception('Fasting session with id $id not found');
    }

    // TODO: Move mappers to extensions
    final mappedFastingSession = api.FastingSession(
      id: fastingSession.id,
      start: fastingSession.start,
      end: fastingSession.end,
      window: fastingSession.window,
    );

    return mappedFastingSession;
  }

  @override
  Future<List<api.FastingSession>> getFastingSessions({
    bool? isActive,
    int? limit,
    DateTime? startAfter,
    DateTime? startBefore,
  }) async {
    final query = _db.select(_db.fastingSessions);

    // Apply filters
    if (isActive != null) {
      if (isActive) {
        query.where((table) => table.end.isNull());
      } else {
        query.where((table) => table.end.isNotNull());
      }
    }

    if (startAfter != null) {
      query.where((table) => table.start.isBiggerThanValue(startAfter));
    }

    if (startBefore != null) {
      query.where((table) => table.start.isSmallerThanValue(startBefore));
    }

    // Order by most recent first
    query.orderBy([
      (table) => OrderingTerm(expression: table.start, mode: OrderingMode.desc),
    ]);

    // Apply limit
    if (limit != null) {
      query.limit(limit);
    }

    final fastingSessions = await query.get();

    return fastingSessions
        .map(
          (session) => api.FastingSession(
            id: session.id,
            start: session.start,
            end: session.end,
            window: session.window,
          ),
        )
        .toList();
  }

  @override
  Future<api.FastingSession> updateFastingSession({
    required int id,
    DateTime? start,
    DateTime? end,
    int? window,
  }) async {
    final companion = FastingSessionsCompanion(
      start: start != null ? Value(start) : const Value.absent(),
      end: end != null ? Value(end) : const Value.absent(),
      window: window != null ? Value(window) : const Value.absent(),
    );

    await (_db.update(
      _db.fastingSessions,
    )..where((table) => table.id.equals(id))).write(companion);

    return await getFastingSessionById(id);
  }

  @override
  Future<void> deleteFastingSession(int id) async {
    await (_db.delete(
      _db.fastingSessions,
    )..where((table) => table.id.equals(id))).go();
  }
}
