import 'package:drift/drift.dart';

class FastingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get window => integer()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime().nullable()();
}
