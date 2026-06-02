import 'package:drift/drift.dart';
import 'package:fasting_api/fasting_api.dart' show FastingSession;

@UseRowClass(FastingSession)
class FastingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime().nullable()();
  IntColumn get window =>
      integer().nullable()(); // window is added on fast completion
  IntColumn get notificationId => integer().nullable()();
}
