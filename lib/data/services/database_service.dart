import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/book.dart';
import '../models/library.dart';
import '../models/series.dart';

final uuid = Uuid();

class DatabaseService {
  Future<void> deleteBook(String id) async {
    final db = await _database();
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteSeries(String id) async {
    final db = await _database();
    await db.delete('series', where: 'id = ?', whereArgs: [id]);
  }

  Future<String> generateId() async {
    return uuid.v7();
  }

  Future<List<Book?>> getAllBooks() async {
    final db = await _database();
    final mapList = await db.query('books');
    return [for (final map in mapList) Book.fromMap(map)];
  }

  Future<List<Series?>> getAllSeries() async {
    final db = await _database();
    final mapList = await db.query('series');
    return [for (final map in mapList) Series.fromMap(map)];
  }

  Future<Book> getBook(String id) async {
    final db = await _database();
    final mapList = await db.query('books', where: 'id = ?', whereArgs: [id]);
    return Book.fromMap(mapList.single);
  }

  Future<Book?> getBookByNameAndSeries(String name, String? seriesId) async {
    final db = await _database();
    final mapList = await db.query(
      'books',
      where: seriesId != null
          ? 'name = ? AND series_id = ?'
          : 'name = ? AND series_id IS NULL',
      whereArgs: seriesId != null ? [name, seriesId] : [name],
    );
    if (mapList.isEmpty) {
      return null;
    } else {
      return Book.fromMap(mapList.single);
    }
  }

  Future<List<Book>> getBooksBySeries(String seriesId) async {
    final db = await _database();
    final mapList = await db.query(
      'books',
      where: 'series_id = ?',
      whereArgs: [seriesId],
    );
    return [for (final map in mapList) Book.fromMap(map)];
  }

  Future<List<Book?>> getInProgressBooks() async {
    final db = await _database();
    final mapList = await db.query(
      'books',
      where: 'reading_status = ?',
      whereArgs: [1],
      orderBy: 'last_read DESC',
    );
    return [for (final map in mapList) Book.fromMap(map)];
  }

  Future<List<Library?>> getLibrary(String? seriesId) async {
    final db = await _database();
    List<Library?> libraryList = [];
    final bookList = await db.query(
      'books',
      where: seriesId != null ? 'series_id = ?' : 'series_id IS NULL',
      whereArgs: seriesId != null ? [seriesId] : null,
      orderBy: 'name',
    );
    for (final book in bookList) {
      libraryList.add(Book.fromMap(book));
    }
    final seriesList = await db.query(
      'series',
      where: seriesId != null ? 'series_id = ?' : 'series_id IS NULL',
      whereArgs: seriesId != null ? [seriesId] : null,
      orderBy: 'name',
    );
    for (final series in seriesList) {
      libraryList.add(Series.fromMap(series));
    }
    if (libraryList.length > 1) {
      libraryList.sort((a, b) => a!.name.compareTo(b!.name));
    }
    return libraryList;
  }

  Future<Series> getSeries(String id) async {
    final db = await _database();
    final mapList = await db.query('series', where: 'id = ?', whereArgs: [id]);
    return Series.fromMap(mapList.single);
  }

  Future<Series?> getSeriesByName(String name) async {
    final db = await _database();
    final mapList = await db.query(
      'series',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (mapList.isEmpty) {
      return null;
    } else {
      return Series.fromMap(mapList.single);
    }
  }

  Future<void> insertBook(Book book) async {
    final db = await _database();
    await db.insert('books', book.toMap());
  }

  Future<void> insertSeries(Series series) async {
    final db = await _database();
    await db.insert('series', series.toMap());
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

  Future<void> updateSeries(Series series) async {
    final db = await _database();
    await db.update(
      'series',
      series.toMap(),
      where: 'id = ?',
      whereArgs: [series.id],
    );
  }

  Future<Database> _database() async {
    // await deleteDatabase('manga_reader.db');
    return openDatabase(
      'manga_reader.db',
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE books (
id TEXT PRIMARY KEY,
current_page INTEGER,
date_added TEXT NOT NULL,
last_read TEXT,
length INTEGER,
name TEXT NOT NULL,
path TEXT NOT NULL,
reading_status INTEGER NOT NULL,
series_id TEXT,
thumbnail TEXT,
FOREIGN KEY(series_id) REFERENCES series(id)
) WITHOUT ROWID;
''');
        await db.execute('''
CREATE TABLE series (
id TEXT PRIMARY KEY,
book_count INTEGER,
date_added TEXT NOT NULL,
name TEXT NOT NULL,
series_id TEXT,
thumbnail TEXT,
FOREIGN KEY(series_id) REFERENCES series(id)
) WITHOUT ROWID;
''');
      },
      version: 1,
    );
  }
}
