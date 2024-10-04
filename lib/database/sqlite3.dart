import 'package:sqlite3/common.dart';
import 'package:sqlite3/sqlite3.dart';

Future<CommonDatabase> openSqliteDatabase() async {
  return sqlite3.openInMemory();
}
