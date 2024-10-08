import 'dart:async' show StreamSubscription;

import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../database/database.dart';
import '../../entities/box.dart';

class BoxDetailsStore with ChangeNotifier {
  BoxDetailsStore({
    required AppDatabase database,
    required this.boxId,
  }) : _db = database {
    _boxSubscription = _db.watchBox(boxId).listen(_onBoxChanged);
    _onBoxChanged(_db.getBoxById(boxId));
    _itemsSubscription = _db.watchBoxItems(boxId).listen(_onItemsChanged);
    _onItemsChanged(_db.getBoxItems(boxId));
  }

  final AppDatabase _db;
  final int boxId;

  StreamSubscription<Box>? _boxSubscription;
  StreamSubscription<List<BoxItem>>? _itemsSubscription;

  List<BoxItem> get items => _items;
  List<BoxItem> _items = [];

  Box get box => _box;
  late Box _box;

  void _onBoxChanged(Box box) {
    _box = box;
    notifyListeners();
  }

  void _onItemsChanged(List<BoxItem> items) {
    _items = items;
    notifyListeners();
  }

  void addItem({
    required String code,
    required String title,
    required String date,
    required String accessPoints,
  }) {
    _db.addItemToBox(
      boxId: boxId,
      code: code,
      title: title,
      date: date,
      accessPoints: accessPoints,
    );
  }

  void updateItem({
    required int itemId,
    required String code,
    required String title,
    required String date,
    required String accessPoints,
  }) {
    _db.updateBoxItem(
      itemId: itemId,
      code: code,
      title: title,
      date: date,
      accessPoints: accessPoints,
    );
  }

  @override
  void dispose() {
    _boxSubscription?.cancel();
    _boxSubscription = null;
    _itemsSubscription?.cancel();
    _itemsSubscription = null;
    super.dispose();
  }
}
