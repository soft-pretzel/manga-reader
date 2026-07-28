import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:saf_util/saf_util_platform_interface.dart';

import '../models/book.dart';
import '../models/library_item.dart';
import '../services/archive_service.dart';
import '../services/file_picker_service.dart';
import '../services/path_provider_service.dart';
import '../services/saf_stream_service.dart';
import '../services/saf_util_service.dart';
import '../services/shared_preferences_service.dart';
import '../services/sqflite_service.dart';
import '../services/uuid_service.dart';
import '../../utils/result.dart';

class BookRepository {
  BookRepository({
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

  String? _previousBook;

  static List<String> bookTypes = ['epub'];
  static List<String> comicTypes = ['tar', 'cbt', 'zip', 'cbz'];
  static List<String> imgTypes = ['jpeg', 'jpg', 'png'];

  Future<Result<List<BookItem?>>> getBooks() async {
    try {
      final books = await _sqfliteService.getAllBooks();
      return Result.ok(books);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Future<void> _saveBook(SafDocumentFile file) async {
  //   final id = _uuidService.generate();
  //   BookType bookType;

  //   final fileType = file.name.split('.').last;
  //   if (bookTypes.contains(fileType)) {
  //     bookType = BookType.book;
  //   } else if (comicTypes.contains(fileType)) {
  //     bookType = BookType.comic;
  //   } else {
  //     bookType = BookType.pdf;
  //   }

  //   Book book = Book(
  //     id: id,
  //     name: file.name.split('.').first,
  //     bookType: bookType,
  //     dateAdded: DateTime.now(),
  //     path: file.uri,
  //     readingStatus: ReadingStatus.notStarted,
  //     series: seriesName,
  //     thumbnail: await _getThumbnail(id, file.uri),
  //   );

  //   await _sqfliteService.insertBook(book);
  // }

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

  Future<Result<List<String>>> openComic(int id) async {
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

  Future<Result<void>> setCurrentBook(int id) async {
    try {
      await _sharedPreferencesService.setCurrentBook(id);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<BookItem?>> getCurrentBook() async {
    try {
      final id = await _sharedPreferencesService.getCurrentBook();
      if (id != null) return Result.ok(await _sqfliteService.getBook(id));
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> updateBook(BookItem book) async {
    try {
      await _sqfliteService.updateBook(book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
