import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';

import '../models/book.dart';
import '../models/folder.dart';
import '../models/library.dart';
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

  static List<String> comicTypes = ['cbt', 'cbz', 'tar', 'zip'];
  static List<String> imgTypes = ['jpeg', 'jpg', 'png'];

  Future<Result<void>> addLocalFolder() async {
    try {
      final path = await _localStorageService.selectFolder();
      if (path != null) {
        final folder = Folder(
          id: await _databaseService.generateId(),
          dateAdded: DateTime.now(),
          name: await _localStorageService.getName(path),
          path: path,
        );
        await _databaseService.insertFolder(folder);
        await parseFolder(folder);
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

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

  Future<Result<Book>> getBook(String id) async {
    try {
      final book = await _databaseService.getBook(id);
      return Result.ok(book);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Uint8List?>> getCover(String path) async {
    try {
      final token = RootIsolateToken.instance;
      final cover = await Isolate.run(() async {
        BackgroundIsolateBinaryMessenger.ensureInitialized(token!);
        return await _localStorageService.extractCover(path);
      });
      return Result.ok(cover);
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

  Future<Result<List<Library>>> getLibrary(String? parentId) async {
    try {
      final List<Library> library = [];
      library.addAll(await _databaseService.getFoldersByParentId(parentId));
      if (parentId != null) {
        library.addAll(await _databaseService.getBooksByParentId(parentId));
      }
      return Result.ok(library);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Future<Result<List<Library?>>> getLibrary(String? folderId) async {
  //   try {
  //     final library = await _databaseService.getLibrary(folderId);
  //     return Result.ok(library);
  //   } on Exception catch (e) {
  //     return Result.error(e);
  //   }
  // }

  // Future<Result<int>> getFolderBookCount(Folder folder) async {
  //   try {
  //     final items = await _databaseService.getLibrary(folder.id);
  //     folder.itemCount = items.length;
  //     _databaseService.updateFolder(folder);
  //     return Result.ok(items.length);
  //   } on Exception catch (e) {
  //     return Result.error(e);
  //   }
  // }

  Future<Result<Folder>> getFolder(String id) async {
    try {
      final folder = await _databaseService.getFolderById(id);
      return Result.ok(folder);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String>> getName(String path) async {
    try {
      final name = await _localStorageService.getName(path);
      return Result.ok(name);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Future<Result<String?>> getThumbnail(Library item) async {
  //   try {
  //     String? thumbnail;
  //     if (item.runtimeType == Folder) {
  //       final folder = item as Folder;
  //       thumbnail = await _getFolderThumbnail(folder);
  //       folder.thumbnail = thumbnail;
  //       _databaseService.updateFolder(folder);
  //     } else {
  //       final book = item as Book;
  //       if (book.thumbnail == null ||
  //           (book.thumbnail != null &&
  //               File(book.thumbnail!).existsSync() == false)) {
  //         thumbnail = await _getBookThumbnail(book);
  //         book.thumbnail = thumbnail;
  //         _databaseService.updateBook(book);
  //       } else {
  //         thumbnail = book.thumbnail;
  //       }
  //     }
  //     return Result.ok(thumbnail);
  //   } on Exception catch (e) {
  //     return Result.error(e);
  //   }
  // }

  Future<Result<List<String>>> openBook(String id) async {
    try {
      final token = RootIsolateToken.instance;
      final pages = await Isolate.run(() async {
        BackgroundIsolateBinaryMessenger.ensureInitialized(token!);
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
          pages.sort((a, b) => a.compareTo(b));
          return pages;
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
                '${i.toString().padLeft(3, '0')}.$fileType',
              );
              pages.add(page);
              i++;
            }
          }
        }
        return pages;
      });
      return Result.ok(pages);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> parseFolder(Folder folder) async {
    try {
      final files = await _localStorageService.getFiles(folder.path);
      for (final file in files) {
        if (await _localStorageService.isDir(file)) {
          final nestedFolder = Folder(
            id: await _databaseService.generateId(),
            dateAdded: DateTime.now(),
            name: await _localStorageService.getName(file),
            parentId: folder.id,
            path: file,
          );
          await _databaseService.insertFolder(nestedFolder);
          await parseFolder(nestedFolder);
        } else {
          final book = Book(
            id: await _databaseService.generateId(),
            cover: await _localStorageService.extractCover(file),
            dateAdded: DateTime.now(),
            name: await _localStorageService.getName(file),
            parentId: folder.id,
            path: file,
          );
          await _databaseService.insertBook(book);
        }
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> updateBook(Book book) async {
    await _databaseService.updateBook(book);
  }

  // Future<void> _saveBook(String path, String? parentId) async {
  //   final name = await _localStorageService.getName(path);
  //   final existingBook = await _databaseService.getBookByNameAndFolder(
  //     name,
  //     parentId,
  //   );
  //   if (existingBook == null) {
  //     final book = Book(
  //       id: await _databaseService.generateId(),
  //       dateAdded: DateTime.now(),
  //       name: await _localStorageService.getName(path),
  //       parentId: parentId,
  //       path: path,
  //     );
  //     await _databaseService.insertBook(book);
  //   }
  // }

  Future<String> _saveFolder(String path, String? parentId) async {
    final name = await _localStorageService.getName(path);
    final existingFolder = await _databaseService.getFolderByName(name);
    if (existingFolder == null) {
      final newFolder = Folder(
        id: await _databaseService.generateId(),
        dateAdded: DateTime.now(),
        name: name,
        parentId: parentId,
        path: path,
      );
      await _databaseService.insertFolder(newFolder);
      return newFolder.id;
    } else {
      return existingFolder.id;
    }
  }
}
