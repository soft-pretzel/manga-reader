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
          itemCount: (await _localStorageService.getFiles(path)).length,
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

  Future<Result<void>> deleteLocalFolder(String id) async {
    try {
      await _databaseService.deleteFolder(id);
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

  Future<Result<void>> markAsFinished(String id) async {
    try {
      final book = await _databaseService.getBook(id);
      book.readingStatus = .finished;
      await _databaseService.updateBook(book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> markAsUnread(String id) async {
    try {
      final book = await _databaseService.getBook(id);
      book.readingStatus = .unread;
      await _databaseService.updateBook(book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

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
      List<String> dirPaths = [];
      List<String> bookPaths = [];
      final files = await _localStorageService.getFiles(folder.path);
      for (final file in files) {
        if (await _localStorageService.isDir(file)) {
          dirPaths.add(file);
        } else {
          bookPaths.add(file);
        }
      }
      for (final path in bookPaths) {
        final id = await _databaseService.generateId();
        final book = Book(
          id: id,
          cover: await _localStorageService.extractCover(path, id),
          dateAdded: DateTime.now(),
          name: await _localStorageService.getName(path),
          pageCount: await _localStorageService.getPageCount(path),
          parentId: folder.id,
          path: path,
        );
        await _databaseService.insertBook(book);
      }
      for (final path in dirPaths) {
        final nestedFolder = Folder(
          id: await _databaseService.generateId(),
          dateAdded: DateTime.now(),
          itemCount: (await _localStorageService.getFiles(path)).length,
          name: await _localStorageService.getName(path),
          parentId: folder.id,
          path: path,
        );
        await _databaseService.insertFolder(nestedFolder);
        await parseFolder(nestedFolder);
      }
      await updateFolderCovers(folder);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> updateBook(Book book) async {
    await _databaseService.updateBook(book);
  }

  Future<void> updateFolderCovers(Folder folder) async {
    final result = await getLibrary(folder.id);
    switch (result) {
      case Ok():
        final library = result.value;
        if (library.length > 1) {
          library.sort((a, b) => a.name.compareTo(b.name));
        }
        final iterator = library.iterator;
        Library? item;
        final List<String?> covers = [];
        while (covers.length < 3) {
          if (iterator.moveNext()) {
            item = iterator.current;
          }
          if (item.runtimeType == Folder) {
            final nestedFolder = item as Folder;
            covers.add(nestedFolder.covers.first);
          } else {
            final nestedBook = item as Book;
            covers.add(nestedBook.cover);
          }
        }
        folder.covers = covers;
        await _databaseService.updateFolder(folder);
      case Error():
        throw result.error;
    }
  }
}
