import 'package:drift/drift.dart';
import 'package:drift_app_database/drift_app_database.dart';
import 'package:notifications_api/notifications_api.dart';

class DriftNotificationsApi implements NotificationsApi {
  final DriftAppDatabase _db;

  DriftNotificationsApi({required DriftAppDatabase db}) : _db = db;

  @override
  Future<Notification> getNotification(int id) async {
    final notification = await (_db.select(
      _db.notifications,
    )..where((table) => table.id.equals(id))).getSingleOrNull();

    if (notification == null) {
      throw Exception('Notification with id $id not found');
    }

    return notification;
  }

  @override
  Future<Notification> createNotification({
    required String titleTKey,
    required String bodyTKey,
    required DateTime scheduledAt,
  }) async {
    final id = await _db
        .into(_db.notifications)
        .insert(
          NotificationsCompanion.insert(
            titleTKey: titleTKey,
            bodyTKey: bodyTKey,
            scheduledAt: scheduledAt,
          ),
        );

    final createdNotification = await getNotification(id);

    return createdNotification;
  }

  @override
  Future<List<Notification>> getNotifications({
    DateTime? from,
    DateTime? to,
  }) async {
    final query = _db.select(_db.notifications);

    if (from != null) {
      query.where((table) => table.scheduledAt.isBiggerThanValue(from));
    }

    if (to != null) {
      query.where((table) => table.scheduledAt.isSmallerThanValue(to));
    }

    return query.get();
  }

  @override
  Future<void> deleteNotification(int id) async {
    await (_db.delete(
      _db.notifications,
    )..where((table) => table.id.equals(id))).go();
  }
}
