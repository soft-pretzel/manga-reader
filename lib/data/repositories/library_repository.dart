import 'dart:async';
import 'dart:io';

import '../models/book_item.dart';
import '../models/folder_item.dart';
import '../models/library_item.dart';
import '../services/database_service.dart';
import '../services/local_storage_service.dart';
import '../../utils/result.dart';

class LibraryRepository {
  LibraryRepository({
    required this._databaseService,
    required this._localStorageService,
  });

  final DatabaseService _databaseService;
  final LocalStorageService _localStorageService;

  static List<String> bookTypes = ['epub'];
  static List<String> comicTypes = ['cbt', 'cbz', 'tar', 'zip'];
  static List<String> imgTypes = ['jpeg', 'jpg', 'png'];

  String? _previousBook;

  Future<Result<String?>> addFolder() async {
    try {
      final path = await _localStorageService.selectFolder();
      if (path != null) {
        final folder = await _saveFolder(path, null);
        return Result.ok(folder);
      } else {
        return Result.ok(null);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<bool>> deleteFolder(String id) async {
    try {
      final result = await _databaseService.deleteFolder(id);
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<BookItem?>>> getAllBooks() async {
    try {
      final books = await _databaseService.getAllBooks();
      return Result.ok(books);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<FolderItem>> getFolder(String id) async {
    try {
      final folder = await _databaseService.getFolder(id);
      return Result.ok(folder);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<LibraryItem>>> getLibraryItems(String? id) async {
    try {
      final items = await _databaseService.getLibraryItems(id);
      return Result.ok(items);
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

  Future<Result<void>> updateBook(BookItem book) async {
    try {
      await _databaseService.updateBook(book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> _parseFolder(FolderItem folder) async {
    final files = await _localStorageService.getFiles(folder.path);
    for (final file in files) {
      if (await _localStorageService.isDir(file)) {
        _saveFolder(file, folder.id);
      } else {
        await _saveBook(file, folder.id);
      }
    }
  }

  Future<void> _saveBook(String path, String parentId) async {
    final id = await _databaseService.generateId();
    final name = await _localStorageService.getName(path);
    final fileType = await _localStorageService.getFileType(path);

    BookType bookType;
    if (bookTypes.contains(fileType)) {
      bookType = BookType.book;
    } else if (comicTypes.contains(fileType)) {
      bookType = BookType.comic;
    } else {
      bookType = BookType.pdf;
    }

    final book = BookItem(
      id: id,
      name: name,
      path: path,
      thumbnail: await _saveThumbnail(id, path),
      bookType: bookType,
      dateAdded: DateTime.now(),
      readingStatus: ReadingStatus.notStarted,
      parentId: parentId,
    );

    _databaseService.insertBook(book);
  }

  Future<String> _saveFolder(String path, String? parentId) async {
    final folders = await _databaseService.getAllFolders();
    String newFolderName = '';

    if (!folders.map((folder) => folder.path).contains(path)) {
      final id = await _databaseService.generateId();
      final name = await _localStorageService.getName(path);
      final folder = FolderItem(
        id: id,
        name: name,
        path: path,
        parentId: parentId,
      );

      _databaseService.insertFolder(folder);
      _parseFolder(folder);
      newFolderName = folder.name;
    }

    return newFolderName;
  }

  Future<String?> _saveThumbnail(String id, String path) async {
    final cache = await _localStorageService.getCache();
    final thumbnailsCache = '${cache.path}${Platform.pathSeparator}thumbnails';
    if (!await Directory(thumbnailsCache).exists()) {
      await Directory(thumbnailsCache).create(recursive: true);
    }

    String? thumbnail;
    final archive = await _localStorageService.decodeArchive(path);
    if (archive != null) {
      for (final file in archive) {
        final fileType = file.name.split('.').last;
        if (imgTypes.contains(fileType)) {
          thumbnail = await _localStorageService.writeArchiveFile(
            file,
            thumbnailsCache,
            '$id.$fileType',
          );
          break;
        }
      }
    }

    return thumbnail;
  }
}
