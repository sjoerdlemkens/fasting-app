import 'package:drift/drift.dart';
import 'package:local_fasting_api/src/db/core/database.dart';

class LocalFastingApi {
  final AppDatabase _db = AppDatabase();

  Future<FastingSession> createFastingSession({required DateTime started}) async {
    final id = await _db.into(_db.fastingSessions).insert(
          FastingSessionsCompanion.insert(start: started),
        );
    final createdFast = getFastingSessionById(id);

    return createdFast;
  }

  Future<FastingSession> getFastingSessionById(int id) async {
    final fastingSession = await (_db.select(_db.fastingSessions)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();

    if (fastingSession == null) {
      throw Exception('Fasting session with id $id not found');
    }

    return fastingSession;
  }

  Future<FastingSession?> getActiveFastingSession() async {
    return await (_db.select(_db.fastingSessions)
          ..where((table) => table.end.isNull())
          ..orderBy([(table) => OrderingTerm(expression: table.start, mode: OrderingMode.desc)]) // Most recent first
          ..limit(1))
        .getSingleOrNull();
  }
}
