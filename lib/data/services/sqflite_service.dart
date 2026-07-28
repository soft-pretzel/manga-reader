import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/library_item.dart';

class SqfliteService {
  Future<Database> _database() async {
    // await deleteDatabase(join(await getDatabasesPath(), 'manga_reader.db'));
    return openDatabase(
      join(await getDatabasesPath(), 'manga_reader.db'),
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE folders (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
path TEXT NOT NULL,
thumbnail TEXT,
parent_id TEXT,
FOREIGN KEY (parent_id) REFERENCES folders(id))
''');
        await db.execute('''
CREATE TABLE books (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
path TEXT NOT NULL,
thumbnail TEXT,
parent_id TEXT,
book_type TEXT NOT NULL,
date_added TEXT NOT NULL,
reading_status TEXT NOT NULL,
last_read TEXT,
current_page INTEGER,
FOREIGN KEY(parent_id) REFERENCES folders(id))
''');
      },
      version: 1,
    );
  }

  Future<int> insertFolder(FolderItem folder) async {
    final db = await _database();
    return await db.insert('folders', folder.toMap());
  }

  Future<FolderItem> getFolder(int id) async {
    final db = await _database();
    final List<Map<String, Object?>> folderMap = await db.query(
      'folders',
      where: 'id = ?',
      whereArgs: [id],
    );
    return FolderItem.fromMap(folderMap.single);
  }

  Future<List<FolderItem>> getAllFolders() async {
    final db = await _database();
    final List<Map<String, Object?>> foldersMap = await db.query('folders');
    return [for (final map in foldersMap) FolderItem.fromMap(map)];
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

  Future<bool> deleteFolder(int id) async {
    final db = await _database();
    final result = await db.delete('folders', where: 'id = ?', whereArgs: [id]);
    return result != 0;
  }

  Future<void> insertBook(BookItem book) async {
    final db = await _database();
    await db.insert('books', book.toMap());
  }

  Future<BookItem> getBook(int id) async {
    final db = await _database();
    final List<Map<String, Object?>> bookMap = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    return BookItem.fromMap(bookMap.single);
  }

  Future<List<BookItem>> getAllBooks() async {
    final db = await _database();
    final List<Map<String, Object?>> booksMap = await db.query('books');
    return [for (final map in booksMap) BookItem.fromMap(map)];
  }

  Future<void> updateBook(BookItem book) async {
    final db = await _database();
    await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> deleteBook(int id) async {
    final db = await _database();
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<LibraryItem>> getLibraryItems(int? parentId) async {
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
    libraryItems.addAll(books.map((map) => BookItem.fromMap(map)));
    return libraryItems;
  }
}
