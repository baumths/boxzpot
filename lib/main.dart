import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'database/database.dart';

Future<void> main() async {
  final database = await AppDatabase.open();
  runApp(BoxzpotApp(database: database));
}
