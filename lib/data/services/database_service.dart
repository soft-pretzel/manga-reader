import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/book_model.dart';
import '../models/library_model.dart';
import '../models/series_model.dart';

final uuid = Uuid();

class DatabaseService {
  Future<String> generateId() async {
    return uuid.v7();
  }

  Future<List<BookModel>> getAllBooks() async {
    final db = await _database();
    final List<Map<String, Object?>> booksMap = await db.query('books');
    return [for (final map in booksMap) BookModel.fromMap(map)];
  }

  Future<BookModel> getBook(String id) async {
    final db = await _database();
    final List<Map<String, Object?>> bookMap = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    return BookModel.fromMap(bookMap.single);
  }

  Future<List<LibraryItem>> getLibraryItems([String? parentId]) async {
    final db = await _database();
    List<LibraryItem> libraryItems = [];
    final List<Map<String, Object?>> folders = await db.query(
      'folders',
      where: parentId != null ? 'parent_id = ?' : 'parent_id IS NULL',
      whereArgs: parentId != null ? [parentId] : null,
    );
    libraryItems.addAll(folders.map((map) => FolderItem.fromMap(map)));
    final List<Map<String, Object?>> books = await db.query(
      'books',
      where: parentId != null ? 'parent_id = ?' : 'parent_id IS NULL',
      whereArgs: parentId != null ? [parentId] : null,
    );
    libraryItems.addAll(books.map((map) => BookModel.fromMap(map)));
    return libraryItems;
  }

  Future<bool> insertBook(BookModel book) async {
    final db = await _database();
    final result = await db.insert('books', book.toMap());
    return result != 0;
  }

  Future<bool> insertFolder(FolderItem folder) async {
    final db = await _database();
    final result = await db.insert('folders', folder.toMap());
    return result != 0;
  }

  Future<bool> updateBook(BookModel book) async {
    final db = await _database();
    final result = await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
    return result != 0;
  }

  Future<bool> updateFolder(FolderItem folder) async {
    final db = await _database();
    final result = await db.update(
      'folders',
      folder.toMap(),
      where: 'id = ?',
      whereArgs: [folder.id],
    );
    return result != 0;
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
folder_id TEXT NOT NULL,
last_read TEXT,
name TEXT NOT NULL,
path TEXT NOT NULL,
reading_status INTEGER NOT NULL,
series_id TEXT,
thumbnail TEXT NOT NULL,
FOREIGN KEY(folder_id) REFERENCES folders(id),
FOREIGN KEY(series_id) REFERENCES series(id)
) WITHOUT ROWID;
''');
        await db.execute('''
CREATE TABLE folders (
id TEXT PRIMARY KEY,
date_added TEXT NOT NULL,
path TEXT NOT NULL,
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
