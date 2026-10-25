import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/book.dart';
import '../models/folder.dart';

final uuid = Uuid();

class DatabaseService {
  static const _name = 'manga_reader.db';

  Future<void> deleteBook(String id) async {
    final db = await _database();
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteFolder(String id) async {
    final db = await _database();
    await db.delete('folders', where: 'id = ?', whereArgs: [id]);
  }

  Future<String> generateId() async {
    return uuid.v7();
  }

  Future<List<Book?>> getAllBooks() async {
    final db = await _database();
    final mapList = await db.query('books');
    return [for (final map in mapList) Book.fromMap(map)];
  }

  Future<List<Folder?>> getAllFolders() async {
    final db = await _database();
    final mapList = await db.query('folders');
    return [for (final map in mapList) Folder.fromMap(map)];
  }

  Future<Book> getBook(String id) async {
    final db = await _database();
    final mapList = await db.query('books', where: 'id = ?', whereArgs: [id]);
    return Book.fromMap(mapList.single);
  }

  Future<List<Book>> getBooksByParentId(String parentId) async {
    final db = await _database();
    final books = await db.query(
      'books',
      where: 'parent_id = ?',
      whereArgs: [parentId],
    );
    return books.map((book) => Book.fromMap(book)).toList();
  }

  Future<FileStat> getDatabaseInfo() async {
    final path = '${await getDatabasesPath()}${Platform.pathSeparator}$_name';
    return await File(path).stat();
  }

  Future<List<Book>> getInProgressBooks() async {
    final db = await _database();
    final books = await db.query(
      'books',
      where: 'reading_status = ?',
      whereArgs: [1],
      orderBy: 'last_read DESC',
    );
    return books.map((book) => Book.fromMap(book)).toList();
  }

  Future<Folder> getFolderById(String id) async {
    final db = await _database();
    final mapList = await db.query('folders', where: 'id = ?', whereArgs: [id]);
    return Folder.fromMap(mapList.single);
  }

  Future<Folder?> getFolderByName(String name) async {
    final db = await _database();
    final mapList = await db.query(
      'folders',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (mapList.isEmpty) {
      return null;
    } else {
      return Folder.fromMap(mapList.single);
    }
  }

  Future<List<Folder>> getFoldersByParentId(String? parentId) async {
    final db = await _database();
    final folders = await db.query(
      'folders',
      where: parentId != null ? 'parent_id = ?' : 'parent_id IS NULL',
      whereArgs: parentId != null ? [parentId] : null,
    );
    return folders.map((folder) => Folder.fromMap(folder)).toList();
  }

  Future<void> insertBook(Book book) async {
    final db = await _database();
    await db.insert('books', book.toMap());
  }

  Future<void> insertFolder(Folder folder) async {
    final db = await _database();
    final existingFolder = await db.query(
      'folders',
      where: folder.parentId != null
          ? 'name = ? AND parent_id = ?'
          : 'name = ? AND parent_id IS NULL',
      whereArgs: folder.parentId != null
          ? [folder.name, folder.parentId]
          : [folder.name],
    );
    if (existingFolder.isEmpty) {
      await db.insert('folders', folder.toMap());
    }
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

  Future<void> updateFolder(Folder folder) async {
    final db = await _database();
    await db.update(
      'folders',
      folder.toMap(),
      where: 'id = ?',
      whereArgs: [folder.id],
    );
  }

  Future<Database> _database() async {
    // await deleteDatabase('manga_reader.db');
    return openDatabase(
      _name,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE books (
id TEXT PRIMARY KEY,
cover TEXT,
current_page INTEGER,
date_added TEXT NOT NULL,
last_read TEXT,
length INTEGER,
name TEXT NOT NULL,
page_count INTEGER NOT NULL,
parent_id TEXT NOT NULL,
path TEXT NOT NULL,
reading_status INTEGER,
FOREIGN KEY(parent_id) REFERENCES folders(id) ON DELETE CASCADE
) WITHOUT ROWID;
''');
        await db.execute('''
CREATE TABLE folders (
id TEXT PRIMARY KEY,
covers TEXT,
date_added TEXT NOT NULL,
item_count INTEGER NOT NULL,
name TEXT NOT NULL,
parent_id TEXT,
path TEXT NOT NULL,
FOREIGN KEY(parent_id) REFERENCES folders(id) ON DELETE CASCADE
) WITHOUT ROWID;
''');
      },
      version: 1,
    );
  }
}
