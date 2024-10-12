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
    _docsSubscription = _db.watchDocumentsByBoxId(boxId).listen(_onDocsChanged);
    _onDocsChanged(_db.getDocumentsByBoxId(boxId));
  }

  final AppDatabase _db;
  final int boxId;

  StreamSubscription<Box>? _boxSubscription;
  StreamSubscription<List<Document>>? _docsSubscription;

  List<Document> get documents => _documents;
  List<Document> _documents = [];

  Box get box => _box;
  late Box _box;

  void _onBoxChanged(Box box) {
    _box = box;
    notifyListeners();
  }

  void _onDocsChanged(List<Document> docs) {
    _documents = docs;
    notifyListeners();
  }

  void addDocument({
    required String code,
    required String title,
    required String date,
    required String accessPoints,
  }) {
    _db.addDocumentToBox(
      boxId: boxId,
      code: code,
      title: title,
      date: date,
      accessPoints: accessPoints,
    );
  }

  void updateDocument({
    required int documentId,
    required String code,
    required String title,
    required String date,
    required String accessPoints,
  }) {
    _db.updateDocument(
      documentId: documentId,
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
    _docsSubscription?.cancel();
    _docsSubscription = null;
    super.dispose();
  }
}
