import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:local_fasting_api/src/db/db.dart';
import 'package:path/path.dart' as path;

part 'database.g.dart';

@DriftDatabase(tables: [FastingSessions])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() => LazyDatabase(() async {
        final dir = await getApplicationSupportDirectory();
        await dir.create(recursive: true);

        final file = File(path.join(dir.path, 'fasting.db'));
        return NativeDatabase(file);
      });
}
