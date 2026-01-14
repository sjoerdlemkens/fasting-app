import 'package:drift/drift.dart';
import 'package:drift_app_database/drift_app_database.dart';

@UseRowClass(FastingSession)
class FastingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime().nullable()();
  IntColumn get window =>
      integer().nullable()(); // window is added on fast completion
}
