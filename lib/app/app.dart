import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../features/boxes_overview/boxes_overview.dart';
import '../features/boxes_overview/boxes_store.dart';

class BoxzpotApp extends StatelessWidget {
  const BoxzpotApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BoxesStore(database)),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Boxzpot',
        home: BoxesOverview(),
      ),
    );
  }
}
