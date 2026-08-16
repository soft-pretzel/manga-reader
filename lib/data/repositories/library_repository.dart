import 'dart:async';
import 'dart:io';

import '../models/book.dart';
import '../models/library.dart';
import '../models/reading_direction.dart';
import '../models/reading_mode.dart';
import '../models/series.dart';
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

  Future<Result<void>> deleteBookCache(String id) async {
    try {
      final cache = await _localStorageService.getReadingCache();
      final bookCache = Directory('${cache.path}${Platform.pathSeparator}$id');
      await bookCache.delete(recursive: true);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<bool>> getAnimations() async {
    try {
      final animations = await _sharedPreferencesService.getAnimations();
      return Result.ok(animations);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Book>> getBook(String id) async {
    try {
      final book = await _databaseService.getBook(id);
      return Result.ok(book);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> getBookThumbnail(Book book) async {
    try {
      final cache = await _localStorageService.getThumbnailCache();

      final archive = await _localStorageService.decodeArchive(book.path);
      String? thumbnail;
      if (archive != null) {
        for (final file in archive) {
          final fileType = file.name.split('.').last;
          if (imgTypes.contains(fileType)) {
            thumbnail = await _localStorageService.writeArchiveFile(
              file,
              cache.path,
              '${book.id}.$fileType',
            );
            break;
          }
        }
      }

      if (thumbnail != null) {
        book.thumbnail = thumbnail;
        _databaseService.updateBook(book);
      }

      return Result.ok(thumbnail);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<Book?>>> getInProgressBooks() async {
    try {
      final books = await _databaseService.getInProgressBooks();
      return Result.ok(books);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<Library?>>> getLibrary(String? seriesId) async {
    try {
      final library = await _databaseService.getLibrary(seriesId);
      return Result.ok(library);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<ReadingDirection>> getReadingDirection() async {
    try {
      final readingDirection = await _sharedPreferencesService
          .getReadingDirection();
      return Result.ok(readingDirection);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<ReadingMode>> getReadingMode() async {
    try {
      final readingMode = await _sharedPreferencesService.getReadingMode();
      return Result.ok(readingMode);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<int>> getSeriesBookCount(Series series) async {
    try {
      final items = await _databaseService.getLibrary(series.id);
      series.bookCount = items.length;
      _databaseService.updateSeries(series);
      return Result.ok(items.length);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String>> getSeriesName(String id) async {
    try {
      final series = await _databaseService.getSeries(id);
      return Result.ok(series.name);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> getSeriesThumbnail(Series series) async {
    try {
      String? thumbnail;

      final books = await _databaseService.getBooksBySeries(series.id);
      books.sort((a, b) => a.name.compareTo(b.name));
      if (books.first.thumbnail == null) {
        final result = await getBookThumbnail(books.first);
        switch (result) {
          case Ok():
            thumbnail = result.value;
          case Error():
            return Result.error(result.error);
        }
      } else {
        thumbnail = books.first.thumbnail;
      }

      if (thumbnail != null) {
        series.thumbnail = thumbnail;
        _databaseService.updateSeries(series);
      }

      return Result.ok(thumbnail);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<String>>> openBook(String id) async {
    try {
      final book = await _databaseService.getBook(id);
      final cache = await _localStorageService.getReadingCache();
      final bookCache = Directory(
        '${cache.path}${Platform.pathSeparator}${book.id}',
      );

      List<String> pages = [];
      if (await bookCache.exists()) {
        await for (final file in bookCache.list()) {
          pages.add(file.path);
        }
        return Result.ok(pages);
      } else {
        await bookCache.create(recursive: true);
      }

      final archive = await _localStorageService.decodeArchive(book.path);
      if (archive != null) {
        var i = 1;
        for (final file in archive) {
          final fileType = file.name.split('.').last;
          if (imgTypes.contains(fileType)) {
            final page = await _localStorageService.writeArchiveFile(
              file,
              bookCache.path,
              i.toString().padLeft(3, '0'),
            );
            pages.add(page);
            i++;
          }
        }
      }

      book.length = pages.length;
      _databaseService.updateBook(book);
      return Result.ok(pages);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> scanFolder() async {
    try {
      final folder = await _sharedPreferencesService.getFolder();
      if (folder != null) {
        List<String> bookList = [];
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
              await _saveBook(file, seriesId[i]);
              bookList.add(file);
            }
          }
          i++;
        }
        final dbBooks = await _databaseService.getAllBooks();
        if (dbBooks.isNotEmpty) {
          for (final book in dbBooks) {
            if (!bookList.contains(book!.path)) {
              await _databaseService.deleteBook(book.id);
            }
          }
        }
        final dbSeries = await _databaseService.getAllSeries();
        if (dbSeries.isNotEmpty) {
          for (final series in dbSeries) {
            if (!seriesId.contains(series!.id)) {
              await _databaseService.deleteSeries(series.id);
            }
          }
        }
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> toggleAnimations() async {
    try {
      await _sharedPreferencesService.setAnimations();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> setReadingDirection(
    ReadingDirection readingDirection,
  ) async {
    try {
      await _sharedPreferencesService.setReadingDirection(readingDirection);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> setReadingMode(ReadingMode readingMode) async {
    try {
      await _sharedPreferencesService.setReadingMode(readingMode);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> _saveBook(String path, String? seriesId) async {
    final name = await _localStorageService.getName(path);
    final existingBook = await _databaseService.getBookByNameAndSeries(
      name,
      seriesId,
    );
    if (existingBook == null) {
      final book = Book(
        id: await _databaseService.generateId(),
        dateAdded: DateTime.now(),
        name: await _localStorageService.getName(path),
        path: path,
        seriesId: seriesId,
      );
      await _databaseService.insertBook(book);
    }
  }

  Future<String> _saveSeries(String path, String? seriesId) async {
    final name = await _localStorageService.getName(path);
    final existingSeries = await _databaseService.getSeriesByName(name);
    if (existingSeries == null) {
      final newSeries = Series(
        id: await _databaseService.generateId(),
        dateAdded: DateTime.now(),
        name: name,
        seriesId: seriesId,
      );
      await _databaseService.insertSeries(newSeries);
      return newSeries.id;
    } else {
      return existingSeries.id;
    }
  }

  Future<void> updateBook(Book book) async {
    await _databaseService.updateBook(book);
  }
}
