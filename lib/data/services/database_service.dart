import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/book_model.dart';
import '../models/folder_model.dart';
import '../models/library_model.dart';
import '../models/series_model.dart';

final uuid = Uuid();

class DatabaseService {
  Future<String> generateId() async {
    return uuid.v7();
  }

  Future<void> insertBook(BookModel book) async {
    final db = await _database();
    await db.insert('books', book.toMap());
  }

  Future<void> insertSeries(SeriesModel series) async {
    final db = await _database();
    await db.insert('folders', series.toMap());
  }

  Future<Database> _database() async {
    final path =
        '${await getDatabasesPath()}${Platform.pathSeparator}manga_reader.db';
    // await deleteDatabase(path);
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE books (
id TEXT PRIMARY KEY,
current_page INTEGER,
date_added TEXT NOT NULL,
last_read TEXT,
name TEXT NOT NULL,
path TEXT NOT NULL,
reading_status INTEGER NOT NULL,
series_id TEXT,
FOREIGN KEY(series_id) REFERENCES series(id)
) WITHOUT ROWID;
''');
        await db.execute('''
CREATE TABLE series (
id TEXT PRIMARY KEY,
date_added TEXT NOT NULL,
name TEXT NOT NULL,
) WITHOUT ROWID;
''');
      },
      version: 1,
    );
  }
}
