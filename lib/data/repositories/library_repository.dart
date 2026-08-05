import 'dart:async';
import 'dart:io';

import '../models/book_model.dart';
import '../models/library_model.dart';
import '../models/series_model.dart';
import '../services/database_service.dart';
import '../services/local_storage_service.dart';
import '../services/shared_preferences_service.dart';
import '../../utils/result.dart';

class LibraryRepository {
  LibraryRepository({
    required this._databaseService,
    required this._localStorageService,
    required this._sharedPreferencesService,
  });

  final DatabaseService _databaseService;
  final LocalStorageService _localStorageService;
  final SharedPreferencesService _sharedPreferencesService;

  static List<String> imgTypes = ['jpeg', 'jpg', 'png'];

  String? _previousBook;

  Future<Result<List<LibraryModel?>>> getLibrary(String? seriesId) async {
    try {
      final library = await _databaseService.getLibrary(seriesId);
      return Result.ok(library);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<BookModel>> getBook(String id) async {
    try {
      final book = await _databaseService.getBook(id);
      return Result.ok(book);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<BookModel?>>> getInProgressBooks() async {
    try {
      final books = await _databaseService.getInProgressBooks();
      return Result.ok(books);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<String>>> openBook(String id) async {
    try {
      final book = await _databaseService.getBook(id);
      final cache = await _localStorageService.getCache();

      final readingCache = Directory(
        '${cache.path}${Platform.pathSeparator}reading',
      );
      if (!await readingCache.exists()) {
        await readingCache.create(recursive: true);
      }

      List<String> pages = [];
      if (book.id == _previousBook) {
        await for (final file in readingCache.list()) {
          pages.add(file.path);
        }
        return Result.ok(pages);
      } else {
        await readingCache.delete(recursive: true);
        await readingCache.create(recursive: true);
      }

      final archive = await _localStorageService.decodeArchive(book.path);
      if (archive != null) {
        for (final file in archive) {
          if (imgTypes.contains(file.name.split('.').last)) {
            final page = await _localStorageService.writeArchiveFile(
              file,
              readingCache.path,
            );
            pages.add(page);
          }
        }
      }

      _previousBook = book.id;
      return Result.ok(pages);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> scanFolder() async {
    try {
      final folder = await _sharedPreferencesService.getFolder();
      if (folder != null) {
        List<String> dirList = [folder];
        List<String?> seriesId = [null];
        int i = 0;
        while (i < dirList.length) {
          final files = await _localStorageService.getFiles(dirList[i]);
          for (final file in files) {
            if (await _localStorageService.isDir(file)) {
              seriesId.add(await _saveSeries(file, seriesId[i]));
              dirList.add(file);
            } else {
              _saveBook(file, seriesId[i]);
            }
          }
          i++;
        }
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> updateBook(BookModel book) async {
    await _databaseService.updateBook(book);
  }

  Future<void> _saveBook(String path, String? seriesId) async {
    final name = await _localStorageService.getName(path);
    final existingBook = await _databaseService.getBookByNameAndSeries(
      name,
      seriesId,
    );
    if (existingBook == null) {
      final book = BookModel(
        id: await _databaseService.generateId(),
        dateAdded: DateTime.now(),
        name: await _localStorageService.getName(path),
        path: path,
        seriesId: seriesId,
      );
      _databaseService.insertBook(book);
    }
  }

  Future<String> _saveSeries(String path, String? seriesId) async {
    final name = await _localStorageService.getName(path);
    final existingSeries = await _databaseService.getSeriesByName(name);
    if (existingSeries == null) {
      final newSeries = SeriesModel(
        id: await _databaseService.generateId(),
        dateAdded: DateTime.now(),
        name: name,
        seriesId: seriesId,
      );
      _databaseService.insertSeries(newSeries);
      return newSeries.id;
    } else {
      return existingSeries.id;
    }
  }
}
