import 'package:sqlite3/common.dart';

void runSqliteMigrations(CommonDatabase db) {
  db.execute(
    """
    CREATE TABLE IF NOT EXISTS boxes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      hash TEXT UNIQUE NOT NULL,
      code TEXT,
      name TEXT,
      description TEXT
    );

    CREATE TABLE IF NOT EXISTS documents (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      box_id INTEGER NOT NULL REFERENCES boxes(id),
      code TEXT,
      title TEXT,
      date TEXT,
      access_points TEXT
    );
    """,
  );

  db.userVersion = 1;
}
