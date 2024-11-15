import 'dart:async' show StreamSubscription;

import 'package:flutter/foundation.dart';

import '../../data/repositories/documents_repository.dart';
import '../../entities/document.dart';

class DocumentsStore extends ChangeNotifier {
  DocumentsStore(this.documentsRepository);

  final DocumentsRepository documentsRepository;

  StreamSubscription<List<Document>>? _docsSubscription;

  int? get boxId => _boxId;
  int? _boxId;

  List<Document> get documents => _documents;
  List<Document> _documents = [];

  void updateBoxId(int? id) {
    if (id == boxId) return;

    if (id == null) {
      _handleBoxClosed();
    } else {
      _handleBoxOpened(id);
    }

    notifyListeners();
  }

  void addDocument({
    required String code,
    required String title,
    required String date,
    required String accessPoints,
  }) {
    assert(boxId != null);
    if (boxId == null) return;

    documentsRepository.createDocument(
      boxId: boxId!,
      code: code,
      title: title,
      date: date,
      accessPoints: accessPoints,
    );
  }

  void deleteDocument(int documentId) {
    documentsRepository.deleteDocument(documentId);
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

  void _handleBoxOpened(int boxId) {
    _boxId = boxId;
    _documents = documentsRepository.getDocumentsByBoxId(boxId);
    _sortDocuments();
    _docsSubscription = documentsRepository
        .watchDocumentsByBoxId(boxId)
        .listen(_handleDocumentsChanged);
  }

  void _handleDocumentsChanged(List<Document> docs) {
    _documents = docs;
    _sortDocuments();
    notifyListeners();
  }

  void _handleBoxClosed() {
    _boxId = null;
    _documents = [];
    _docsSubscription?.cancel();
    _docsSubscription = null;
  }

  void _sortDocuments() {
    _documents.sort((a, b) {
      final cmp = a.code.compareTo(b.code);
      return cmp == 0 ? a.title.compareTo(b.title) : cmp;
    });
  }

  @override
  void dispose() {
    _handleBoxClosed();
    super.dispose();
  }
}
