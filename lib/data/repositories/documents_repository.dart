import 'package:sqlite3/common.dart';

import '../../entities/document.dart';

class DocumentsRepository {
  DocumentsRepository(CommonDatabase db) : _db = db;

  final CommonDatabase _db;

  Document createDocument({
    required int boxId,
    required String code,
    required String title,
    required String date,
    required String accessPoints,
  }) {
    final result = _db.select(
      'INSERT INTO documents(box_id, code, title, date, access_points) VALUES (?, ?, ?, ?, ?) RETURNING id',
      [boxId, code, title, date, accessPoints],
    );
    return Document(
      id: result.rows.first[0] as int,
      boxId: boxId,
      code: code,
      title: title,
      date: date,
      accessPoints: accessPoints,
    );
  }

  void deleteDocument(int id) {
    _db.execute('DELETE FROM documents WHERE id = ?', [id]);
  }

  List<Document> getDocumentsByBoxId(int boxId) {
    final result = _db.select(
      'SELECT id, code, title, date, access_points FROM documents WHERE box_id = ?',
      [boxId],
    );
    return result.rows.map((List<Object?> row) {
      return Document(
        id: row[0] as int,
        boxId: boxId,
        code: row[1] as String? ?? '',
        title: row[2] as String? ?? '',
        date: row[3] as String? ?? '',
        accessPoints: row[4] as String? ?? '',
      );
    }).toList(growable: false);
  }

  void updateDocument({
    required int id,
    String? code,
    String? title,
    String? date,
    String? accessPoints,
  }) {
    _db.execute(
      'UPDATE documents SET code = ?, title = ?, date = ?, access_points = ? WHERE id = ?',
      [code, title, date, accessPoints, id],
    );
  }

  Stream<List<Document>> watchDocumentsByBoxId(int boxId) => _db.updates
      .where((update) => update.tableName == 'documents')
      .map((_) => getDocumentsByBoxId(boxId));
}
