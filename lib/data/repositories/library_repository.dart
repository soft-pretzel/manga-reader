import 'dart:async';
import 'dart:io';

import 'package:manga_reader/data/models/book.dart';
import 'package:manga_reader/data/services/path_provider_service.dart';
import 'package:path/path.dart';

import '../services/archive_service.dart';
import '../services/file_picker_service.dart';
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

  static List<String> imgTypes = ['jpeg', 'jpg', 'png'];

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

  Future<Result<List<Book>>> getBooks() async {
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
              Book book = Book(
                id: id,
                dateAdded: DateTime.now(),
                name: file.name.split('.').first,
                uri: file.uri,
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
        for (final byte in bytes) {
          bytesList.add(byte);
        }
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

  Future<Result<List<String>>> parseBook(String id, String uri) async {
    try {
      final cacheDir = await _pathProviderService.getCache();
      final bookDir = Directory(join(cacheDir.path, 'reading', id));
      List<String> files = [];
      if (await bookDir.exists()) {
        await for (final file in bookDir.list()) {
          files.add(file.path);
        }
        return Result.ok(files);
      } else {
        await bookDir.create(recursive: true);
      }
      final fileStream = await _safStreamService.readFileStream(uri);
      List<int> bytesList = [];
      await for (final bytes in fileStream) {
        for (final byte in bytes) {
          bytesList.add(byte);
        }
      }
      final archive = await _archiveService.extractZip(bytesList);
      for (final file in archive) {
        if (imgTypes.contains(file.name.split('.').last)) {
          final filePath = join(bookDir.path, file.name);
          await File(filePath).writeAsBytes(file.readBytes() as List<int>);
          files.add(filePath);
        }
      }
      return Result.ok(files);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
