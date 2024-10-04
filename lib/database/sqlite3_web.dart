import 'package:sqlite3/wasm.dart';

Future<CommonDatabase> openSqliteDatabase() async {
  const databaseName = 'boxzpot';
  final sqlite = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
  final fileSystem = await IndexedDbFileSystem.open(dbName: databaseName);
  sqlite.registerVirtualFileSystem(fileSystem, makeDefault: true);
  return sqlite.open('boxzpot');
}
