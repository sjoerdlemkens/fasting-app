import 'package:drift/drift.dart';
import 'package:notifications_api/notifications_api.dart' show Notification;

@UseRowClass(Notification)
class Notifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titleTKey => text()();
  TextColumn get bodyTKey => text()();
  DateTimeColumn get scheduledAt => dateTime()();
}
