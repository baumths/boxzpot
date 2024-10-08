import 'package:sqlite3/common.dart';

import '../entities/box.dart';
import 'nanoid.dart';
import 'sqlite3.dart' if (dart.library.js_interop) 'sqlite3_web.dart';

class AppDatabase {
  AppDatabase._(this._db);

  final CommonDatabase _db;

  static Future<AppDatabase> open() async {
    final sqlite = await openSqliteDatabase();

    sqlite.execute("""
      PRAGMA foreign_keys = ON;

      CREATE TABLE IF NOT EXISTS boxes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hash TEXT UNIQUE NOT NULL,
        code TEXT,
        name TEXT,
        description TEXT
      );

      CREATE TABLE IF NOT EXISTS items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        box_id INTEGER NOT NULL REFERENCES boxes(id) ON DELETE CASCADE,
        code TEXT,
        title TEXT,
        date TEXT,
        access_points TEXT
      );
      """);

    return AppDatabase._(sqlite);
  }

  List<Box> getAllBoxes() {
    final result = _db.select(
      'SELECT id, hash, code, name, description FROM boxes',
    );
    return result.rows.map(_boxFromRow).toList(growable: false);
  }

  Box getBoxById(int boxId) {
    final result = _db.select(
      'SELECT id, hash, code, name, description FROM boxes WHERE id = ?',
      [boxId],
    );
    return _boxFromRow(result.rows.first);
  }

  List<BoxItem> getBoxItems(int boxId) {
    final result = _db.select(
      'SELECT id, code, title, date, access_points FROM items WHERE box_id = ?',
      [boxId],
    );
    return result.rows.map((List<Object?> row) {
      return BoxItem(
        id: row[0] as int,
        boxId: boxId,
        code: row[1] as String? ?? '',
        title: row[2] as String? ?? '',
        date: row[3] as String? ?? '',
        accessPoints: row[4] as String? ?? '',
      );
    }).toList(growable: false);
  }

  Box createBox({
    required String code,
    required String name,
    required String description,
  }) {
    final hash = nanoid(length: 16, alphabet: Alphabet.noLookAlikesSafe);
    final result = _db.select(
      'INSERT INTO boxes(hash, code, name, description) VALUES (?, ?, ?, ?) RETURNING id',
      [hash, code, name, description],
    );
    return Box(
      id: result.rows.first[0] as int,
      hash: hash,
      code: code,
      name: name,
      description: description,
    );
  }

  void deleteBox(int boxId) {
    _db.execute('DELETE FROM boxes WHERE id = ?', [boxId]);
  }

  void updateBox({
    required int boxId,
    String? code,
    String? name,
    String? description,
  }) {
    _db.execute(
      """
      UPDATE boxes SET
        code = ?,
        name = ?,
        description = ?
      WHERE id = ?
      """,
      [
        code,
        name,
        description,
        boxId,
      ],
    );
  }

  BoxItem addItemToBox({
    required int boxId,
    required String code,
    required String title,
    required String date,
    required String accessPoints,
  }) {
    final result = _db.select(
      'INSERT INTO items(box_id, code, title, date, access_points) VALUES (?, ?, ?, ?, ?) RETURNING id',
      [boxId, code, title, date, accessPoints],
    );
    return BoxItem(
      id: result.rows.first[0] as int,
      boxId: boxId,
      code: code,
      title: title,
      date: date,
      accessPoints: accessPoints,
    );
  }

  void updateBoxItem({
    required int itemId,
    String? code,
    String? title,
    String? date,
    String? accessPoints,
  }) {
    _db.execute(
      """
      UPDATE items SET
        code = ?,
        title = ?,
        date = ?,
        access_points = ?
      WHERE id = ?
      """,
      [
        code,
        title,
        date,
        accessPoints,
        itemId,
      ],
    );
  }

  void deleteBoxItem(int itemId) {
    _db.execute('DELETE FROM items WHERE id = ?', [itemId]);
  }

  Stream<List<Box>> watchAllBoxes() => _db.updates
      .where((update) => update.tableName == 'boxes')
      .map((_) => getAllBoxes());

  Stream<Box> watchBox(int boxId) => _db.updates
      .where((update) => update.tableName == 'boxes')
      .map((_) => getBoxById(boxId));

  Stream<List<BoxItem>> watchBoxItems(int boxId) => _db.updates
      .where((update) => update.tableName == 'items')
      .map((_) => getBoxItems(boxId));

  Box _boxFromRow(List<Object?> row) {
    return Box(
      id: row[0] as int,
      hash: row[1] as String,
      code: row[2] as String? ?? '',
      name: row[3] as String? ?? '',
      description: row[4] as String? ?? '',
    );
  }
}
