import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/book.dart';

class SqfliteService {
  Future<Database> _database() async {
    // await deleteDatabase(join(await getDatabasesPath(), 'manga_reader.db'));
    return openDatabase(
      join(await getDatabasesPath(), 'manga_reader.db'),
      onCreate: (db, version) {
        return db.execute('''
CREATE TABLE books (
id TEXT PRIMARY KEY NOT NULL,
date_added TEXT NOT NULL,
name TEXT NOT NULL,
path TEXT,
uri TEXT,
series TEXT,
last_read TEXT,
thumbnail TEXT)
          ''');
      },
      version: 1,
    );
  }

  Future<void> insertBook(Book book) async {
    final db = await _database();
    await db.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Book>> getBooks() async {
    final db = await _database();
    final List<Map<String, Object?>> booksMap = await db.query('books');
    return [for (final map in booksMap) Book.fromMap(map)];
  }

  Future<Book> getBook(String id) async {
    final db = await _database();
    final List<Map<String, Object?>> booksMap = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    return [for (final map in booksMap) Book.fromMap(map)].first;
  }

  Future<void> updateBook(Book book) async {
    final db = await _database();
    await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> deleteBook(String id) async {
    final db = await _database();
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }
}
