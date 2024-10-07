import 'dart:async';

import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../database/database.dart';
import '../../entities/box.dart';

class BoxesStore with ChangeNotifier {
  BoxesStore(this._db) {
    _subscription = _db.watchAllBoxes().listen(_onBoxesChanged);
    _onBoxesChanged(_db.getAllBoxes());
  }

  final AppDatabase _db;

  StreamSubscription<List<Box>>? _subscription;

  List<Box> get boxes => _boxes;
  List<Box> _boxes = [];

  void _onBoxesChanged(List<Box> boxes) {
    _boxes = boxes;
    notifyListeners();
  }

  void createBox({
    required String code,
    required String name,
    required String description,
  }) {
    _db.createBox(
      code: code,
      name: name,
      description: description,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _boxes = [];
    super.dispose();
  }
}
