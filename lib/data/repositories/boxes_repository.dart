import 'package:sqlite3/common.dart';

import '../../entities/box.dart';
import '../nanoid.dart';

class BoxesRepository {
  BoxesRepository(CommonDatabase db) : _db = db;

  final CommonDatabase _db;

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

  void deleteBox(int id) {
    _db.execute('DELETE FROM boxes WHERE id = ?', [id]);
  }

  List<Box> getAllBoxes() {
    final result = _db.select('SELECT * FROM boxes');
    return result.rows.map(_boxFromRow).toList(growable: false);
  }

  Box getBoxById(int id) {
    final result = _db.select('SELECT * FROM boxes WHERE id = ?', [id]);
    return _boxFromRow(result.rows.first);
  }

  void updateBox({
    required int id,
    String? code,
    String? name,
    String? description,
  }) {
    _db.execute(
      'UPDATE boxes SET code = ?, name = ?, description = ? WHERE id = ?',
      [code, name, description, id],
    );
  }

  Stream<List<Box>> watchAllBoxes() => _db.updates
      .where((update) => update.tableName == 'boxes')
      .map((_) => getAllBoxes());

  Stream<Box> watchBox(int id) => _db.updates
      .where((update) => update.tableName == 'boxes')
      .map((_) => getBoxById(id));

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
