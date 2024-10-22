import 'dart:async' show StreamSubscription;

import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../data/repositories/boxes_repository.dart';
import '../../data/repositories/documents_repository.dart';
import '../../entities/box.dart';
import '../../entities/document.dart';

class BoxDetailsStore with ChangeNotifier {
  BoxDetailsStore({
    required this.boxesRepository,
    required this.documentsRepository,
    required this.boxId,
  }) {
    _boxSubscription = boxesRepository.watchBox(boxId).listen(_onBoxChanged);
    _onBoxChanged(boxesRepository.getBoxById(boxId));
    _docsSubscription =
        documentsRepository.watchDocumentsByBoxId(boxId).listen(_onDocsChanged);
    _onDocsChanged(documentsRepository.getDocumentsByBoxId(boxId));
  }

  final BoxesRepository boxesRepository;
  final DocumentsRepository documentsRepository;
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
    documentsRepository.createDocument(
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
    documentsRepository.updateDocument(
      id: documentId,
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
