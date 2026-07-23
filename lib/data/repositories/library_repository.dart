import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';

import '../models/book.dart';
import '../services/archive_service.dart';
import '../services/file_picker_service.dart';
import '../services/path_provider_service.dart';
import '../services/saf_stream_service.dart';
import '../services/saf_util_service.dart';
import '../services/shared_preferences_service.dart';
import '../services/sqflite_service.dart';
import '../services/uuid_service.dart';
import '../../utils/result.dart';

class LibraryRepository {
  LibraryRepository({
    required this._archiveService,
    required this._filePickerService,
    required this._pathProviderService,
    required this._safStreamService,
    required this._safUtilService,
    required this._sharedPreferencesService,
    required this._sqfliteService,
    required this._uuidService,
  });

  final ArchiveService _archiveService;
  final FilePickerService _filePickerService;
  final PathProviderService _pathProviderService;
  final SafStreamService _safStreamService;
  final SafUtilService _safUtilService;
  final SharedPreferencesService _sharedPreferencesService;
  final SqfliteService _sqfliteService;
  final UuidService _uuidService;

  static List<String> bookTypes = ['epub'];
  static List<String> comicTypes = ['tar', 'cbt', 'zip', 'cbz'];
  static List<String> imgTypes = ['jpeg', 'jpg', 'png'];

  String? _previousBook;

  Future<Result<List<String>>> addFolder() async {
    try {
      final foldersList = await _sharedPreferencesService.getFolders();
      final foldersSet = foldersList.toSet();
      final folder = await _safUtilService.selectFolder();
      if (folder != null) {
        if (foldersSet.add(folder.uri)) {
          await _sharedPreferencesService.setFolders(foldersSet.toList());
          await _parseFolder(folder.uri);
        }
      }
      return Result.ok(foldersSet.toList());
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<String>>> deleteFolder(String folder) async {
    try {
      final folders = await _sharedPreferencesService.getFolders();
      if (folders.remove(folder)) {
        await _sharedPreferencesService.setFolders(folders);
      }
      return Result.ok(folders);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<String>>> getFolders() async {
    try {
      final folders = await _sharedPreferencesService.getFolders();
      return Result.ok(folders);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<Book>?>> getBooks() async {
    try {
      final books = await _sqfliteService.getBooks();
      return Result.ok(books);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _parseFolder(String uri) async {
    try {
      final files = await _safUtilService.getFiles(uri);
      for (var file in files) {
        if (file.isDir) {
          String seriesName = file.name;
          final files = await _safUtilService.getFiles(file.uri);
          for (var file in files) {
            if (!file.isDir) {
              final id = _uuidService.generate();
              BookType bookType;

              final fileType = file.name.split('.').last;
              if (bookTypes.contains(fileType)) {
                bookType = BookType.book;
              } else if (comicTypes.contains(fileType)) {
                bookType = BookType.comic;
              } else {
                bookType = BookType.pdf;
              }

              Book book = Book(
                id: id,
                name: file.name.split('.').first,
                bookType: bookType,
                dateAdded: DateTime.now(),
                path: file.uri,
                readingStatus: ReadingStatus.notStarted,
                series: seriesName,
                thumbnail: await _getThumbnail(id, file.uri),
              );

              await _sqfliteService.insertBook(book);
            }
          }
        }
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<String> _getThumbnail(String id, String uri) async {
    try {
      final cacheDir = await _pathProviderService.getCache();
      if (await File(join(cacheDir.path, id)).exists()) {
        return join(cacheDir.path, id);
      }

      final fileStream = await _safStreamService.readFileStream(uri);
      List<int> bytesList = [];
      await for (final bytes in fileStream) {
        bytesList.addAll(bytes);
      }
      final archive = await _archiveService.extractZip(bytesList);
      for (final file in archive) {
        if (imgTypes.contains(file.name.split('.').last)) {
          final thumbnail = await File(
            join(cacheDir.path, id),
          ).writeAsBytes(file.readBytes() as List<int>);
          return thumbnail.path;
        }
      }
      return '';
    } on Exception {
      rethrow;
    }
  }

  Future<Result<List<String>>> openComic(String id) async {
    try {
      final book = await _sqfliteService.getBook(id);
      final cache = await _pathProviderService.getCache();
      final readingCache = Directory(join(cache.path, 'reading'));
      List<String> pages = [];

      if (!await readingCache.exists()) {
        await readingCache.create(recursive: true);
      }

      if (book.name == _previousBook) {
        await for (final file in readingCache.list()) {
          pages.add(file.path);
        }
        return Result.ok(pages);
      } else {
        await readingCache.delete(recursive: true);
        await readingCache.create(recursive: true);
      }

      final fileStream = await _safStreamService.readFileStream(book.path);
      List<int> bytesList = [];
      await for (final bytes in fileStream) {
        bytesList.addAll(bytes);
      }
      final archive = await _archiveService.extractZip(bytesList);
      for (final file in archive) {
        if (imgTypes.contains(file.name.split('.').last)) {
          final filePath = join(readingCache.path, file.name);
          await File(filePath).writeAsBytes(file.readBytes() as List<int>);
          pages.add(filePath);
        }
      }
      _previousBook = book.name;
      return Result.ok(pages);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> setCurrentBook(String id) async {
    try {
      await _sharedPreferencesService.setCurrentBook(id);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Book>> getCurrentBook() async {
    try {
      final id = await _sharedPreferencesService.getCurrentBook();
      final currentBook = await _sqfliteService.getBook(id);
      return Result.ok(currentBook);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> updateBook(Book book) async {
    try {
      await _sqfliteService.updateBook(book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
