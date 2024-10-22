import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite3/common.dart';

import '../data/repositories/boxes_repository.dart';
import '../data/repositories/documents_repository.dart';
import '../shared/boxes_store.dart';

class DependenciesProvider extends StatelessWidget {
  const DependenciesProvider({
    super.key,
    required this.database,
    required this.child,
  });

  final CommonDatabase database;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final boxesRepository = BoxesRepository(database);
    final documentsRepository = DocumentsRepository(database);

    return MultiProvider(
      providers: [
        Provider<BoxesRepository>.value(value: boxesRepository),
        Provider<DocumentsRepository>.value(value: documentsRepository),
        ChangeNotifierProvider(create: (_) => BoxesStore(boxesRepository)),
      ],
      child: child,
    );
  }
}
