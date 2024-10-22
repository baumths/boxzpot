import 'package:sqlite3/common.dart';

Future<CommonDatabase> openSqliteDatabase() async {
  throw UnsupportedError("Unable to connect to the database on this platform.");
}
