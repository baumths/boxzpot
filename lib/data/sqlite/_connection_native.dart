import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:sqlite3/common.dart';
import 'package:sqlite3/sqlite3.dart';

Future<CommonDatabase> openSqliteDatabase() async {
  return kDebugMode ? sqlite3.open('boxzpot.debug.db') : sqlite3.openInMemory();
}
