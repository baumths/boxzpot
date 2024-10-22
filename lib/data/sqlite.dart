import 'package:sqlite3/common.dart';

import 'sqlite/connection.dart' show openSqliteDatabase;
import 'sqlite/migrations.dart' show runSqliteMigrations;

Future<CommonDatabase> initSqliteDatabase() async {
  final db = await openSqliteDatabase();
  runSqliteMigrations(db);
  return db;
}
