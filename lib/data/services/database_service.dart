import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/book_model.dart';
import '../models/library_model.dart';
import '../models/series_model.dart';

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

  Future<List<BookModel?>> getAllBooks() async {
    final db = await _database();
    final mapList = await db.query('books');
    return [for (final map in mapList) BookModel.fromMap(map)];
  }

  Future<List<SeriesModel?>> getAllSeries() async {
    final db = await _database();
    final mapList = await db.query('series');
    return [for (final map in mapList) SeriesModel.fromMap(map)];
  }

  Future<BookModel> getBook(String id) async {
    final db = await _database();
    final mapList = await db.query('books', where: 'id = ?', whereArgs: [id]);
    return BookModel.fromMap(mapList.single);
  }

  Future<BookModel?> getBookByNameAndSeries(
    String name,
    String? seriesId,
  ) async {
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
      return BookModel.fromMap(mapList.single);
    }
  }

  Future<List<BookModel>> getBooksBySeries(String seriesId) async {
    final db = await _database();
    final mapList = await db.query(
      'books',
      where: 'series_id = ?',
      whereArgs: [seriesId],
    );
    return [for (final map in mapList) BookModel.fromMap(map)];
  }

  Future<List<BookModel?>> getInProgressBooks() async {
    final db = await _database();
    final mapList = await db.query(
      'books',
      where: 'reading_status = ?',
      whereArgs: [1],
      orderBy: 'last_read',
    );
    return [for (final map in mapList) BookModel.fromMap(map)];
  }

  Future<List<LibraryModel?>> getLibrary(String? seriesId) async {
    final db = await _database();
    List<LibraryModel?> libraryList = [];
    final bookList = await db.query(
      'books',
      where: seriesId != null ? 'series_id = ?' : 'series_id IS NULL',
      whereArgs: seriesId != null ? [seriesId] : null,
      orderBy: 'name',
    );
    for (final book in bookList) {
      libraryList.add(BookModel.fromMap(book));
    }
    final seriesList = await db.query(
      'series',
      where: seriesId != null ? 'series_id = ?' : 'series_id IS NULL',
      whereArgs: seriesId != null ? [seriesId] : null,
      orderBy: 'name',
    );
    for (final series in seriesList) {
      libraryList.add(SeriesModel.fromMap(series));
    }
    if (libraryList.length > 1) {
      libraryList.sort((a, b) => a!.name.compareTo(b!.name));
    }
    return libraryList;
  }

  Future<SeriesModel> getSeries(String id) async {
    final db = await _database();
    final mapList = await db.query('series', where: 'id = ?', whereArgs: [id]);
    return SeriesModel.fromMap(mapList.single);
  }

  Future<SeriesModel?> getSeriesByName(String name) async {
    final db = await _database();
    final mapList = await db.query(
      'series',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (mapList.isEmpty) {
      return null;
    } else {
      return SeriesModel.fromMap(mapList.single);
    }
  }

  Future<void> insertBook(BookModel book) async {
    final db = await _database();
    await db.insert('books', book.toMap());
  }

  Future<void> insertSeries(SeriesModel series) async {
    final db = await _database();
    await db.insert('series', series.toMap());
  }

  Future<void> updateBook(BookModel book) async {
    final db = await _database();
    await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> updateSeries(SeriesModel series) async {
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
