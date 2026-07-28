import 'dart:async';
import 'dart:io';
import 'dart:ui';

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

class FolderRepository {
  FolderRepository({
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

  Future<Result<FolderItem?>> addFolder() async {
    try {
      FolderItem? folder;
      if (Platform.isAndroid) {
        final uri = await _safUtilService.selectFolder();
        if (uri != null) {
          final folders = await _sqfliteService.getAllFolders();
          if (!folders.map((folder) => folder.path).contains(uri)) {
            folder = FolderItem(
              name: await _safUtilService.getName(uri),
              path: uri,
            );
          }
        }
      } else {
        final path = await _filePickerService.selectFolder();
        if (path != null) {
          final folders = await _sqfliteService.getAllFolders();
          if (!folders.map((folder) => folder.path).contains(path)) {
            folder = FolderItem(
              name: path.split(Platform.pathSeparator).last,
              path: path,
            );
          }
        }
      }
      if (folder != null) {
        final id = await _sqfliteService.insertFolder(folder);
        _parseFolder(await _sqfliteService.getFolder(id));
        return Result.ok(folder);
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<FolderItem>> getFolder(int id) async {
    try {
      final folder = await _sqfliteService.getFolder(id);
      return Result.ok(folder);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<LibraryItem>>> getLibraryItems(int? id) async {
    try {
      final items = await _sqfliteService.getLibraryItems(id);
      return Result.ok(items);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<bool>> deleteFolder(int id) async {
    try {
      final result = await _sqfliteService.deleteFolder(id);
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> _parseFolder(FolderItem folder) async {
    int i = 0;
    List<FolderItem> folders = [folder];
    while (i < folders.length) {
      final currentFolder = folders[i];
      final files = await _safUtilService.getFiles(currentFolder.path);
      for (final path in files) {
        if (await _safUtilService.isDir(path)) {
          final newFolder = FolderItem(
            name: await _safUtilService.getName(path),
            path: path,
            parentId: currentFolder.id,
          );

          final id = await _sqfliteService.insertFolder(newFolder);
          folders.add(await _sqfliteService.getFolder(id));
        } else {
          var fileName = await _safUtilService.getName(path);
          final fileType = fileName.split('.').last;
          fileName = fileName.substring(
            0,
            fileName.length - (fileType.length + 1),
          );

          BookType bookType;
          if (bookTypes.contains(fileType)) {
            bookType = BookType.book;
          } else if (comicTypes.contains(fileType)) {
            bookType = BookType.comic;
          } else {
            bookType = BookType.pdf;
          }

          final newBook = BookItem(
            name: fileName,
            path: path,
            thumbnail: await _getThumbnail(fileName, path),
            bookType: bookType,
            dateAdded: DateTime.now(),
            readingStatus: ReadingStatus.notStarted,
            parentId: currentFolder.id,
          );

          _sqfliteService.insertBook(newBook);
        }
      }
      i++;
    }
  }

  Future<void> _saveFolder(String path) async {
    final folder = FolderItem(
      name: await _safUtilService.getName(path),
      path: path,
    );
    _sqfliteService.insertFolder(folder);
  }

  Future<String> _getThumbnail(String fileName, String path) async {
    try {
      final cacheDir = await _pathProviderService.getCache();
      String filePath = '${cacheDir.path}${Platform.pathSeparator}$fileName';
      if (await File(filePath).exists()) return filePath;

      final fileStream = await _safStreamService.readFileStream(path);
      List<int> bytesList = [];
      await for (final bytes in fileStream) {
        bytesList.addAll(bytes);
      }
      final archive = await _archiveService.extractZip(bytesList);
      for (final file in archive) {
        if (imgTypes.contains(file.name.split('.').last)) {
          final thumbnail = await File(
            filePath,
          ).writeAsBytes(file.readBytes() as List<int>);
          return thumbnail.path;
        }
      }
      return '';
    } on Exception {
      rethrow;
    }
  }
}
