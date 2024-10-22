import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/dependencies_provider.dart';
import 'data/sqlite.dart';

Future<void> main() async {
  final database = await initSqliteDatabase();
  runApp(DependenciesProvider(database: database, child: const BoxzpotApp()));
}
