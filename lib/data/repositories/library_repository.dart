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

  Future<Result<Folder?>> addLocalFolder() async {
    try {
      final path = await _localStorageService.selectFolder();
      if (path != null) {
        final folder = Folder(
          id: await _databaseService.generateId(),
          dateAdded: DateTime.now(),
          itemCount: (await _localStorageService.getFiles(path)).length,
          name: await _localStorageService.getFileName(path),
          path: path,
          parsing: true,
        );
        await _databaseService.insertFolder(folder);
        return Result.ok(folder);
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deleteLocalFolder(Folder folder) async {
    try {
      _databaseService.deleteFolder(folder.id);
      _localStorageService.clearStorageAccess(folder.path);
      final childFolders = await _databaseService.getFoldersByParentId(
        folder.id,
      );
      for (final childFolder in childFolders) {
        await deleteLocalFolder(childFolder);
      }
      final childBooks = await _databaseService.getBooksByParentId(folder.id);
      for (final childBook in childBooks) {
        _databaseService.deleteBook(childBook.id);
        final cache = await _localStorageService.getCoversCache();
        final files = cache.listSync(followLinks: false);
        for (final file in files) {
          final name = (file.path.split(Platform.pathSeparator).last)
              .split('.')
              .first;
          if (name == childBook.id) {
            file.delete();
          }
        }
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

  Future<Result<String>> getBookCover(String path, String id) async {
    try {
      final cover = await _localStorageService.extractBookCover(path, id);
      return Result.ok(cover ?? '');
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<Book>>> getInProgressBooks() async {
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
      final name = await _localStorageService.getFileName(path);
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

  Future<Result<void>> parseLocalFolder(Folder folder) async {
    try {
      final items = await _localStorageService.getFiles(folder.path);
      for (final item in items) {
        if (await _localStorageService.isDir(item)) {
          final newFolder = Folder(
            id: await _databaseService.generateId(),
            dateAdded: DateTime.now(),
            itemCount: (await _localStorageService.getFiles(item)).length,
            name: await _localStorageService.getFileName(item),
            parentId: folder.id,
            path: item,
          );
          await _databaseService.insertFolder(newFolder);
          await parseLocalFolder(newFolder);
        } else {
          final structure = await _localStorageService.getBookStructure(item);
          final newBook = Book(
            id: await _databaseService.generateId(),
            dateAdded: DateTime.now(),
            name:
                structure.metadata.title ??
                await _localStorageService.getFileName(item),
            pageCount: structure.files.images.length,
            parentId: folder.id,
            path: item,
          );
          await _databaseService.insertBook(newBook);
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

  Future<void> updateFolder(Folder folder) async {
    await _databaseService.updateFolder(folder);
  }

  Future<Result<String>> getFolderCover(String id, int i) async {
    final List<Library> library = [];
    library.addAll(await _databaseService.getFoldersByParentId(id));
    library.addAll(await _databaseService.getBooksByParentId(id));
    if (library.length < i + 1) return Result.ok('');
    if (library.length > 1) {
      library.sort((a, b) => a.name.compareTo(b.name));
    }
    final item = library[i];
    if (item.runtimeType == Book) {
      final book = item as Book;
      if (book.cover == null) {
        final cover = await _localStorageService.extractBookCover(
          book.path,
          book.id,
        );
        book.cover = cover;
        _databaseService.updateBook(book);
      } else if (book.cover != '') {
        if (!File(book.cover!).existsSync()) {
          final cover = await _localStorageService.extractBookCover(
            book.path,
            book.id,
          );
          book.cover = cover;
          _databaseService.updateBook(book);
        }
      }
      return Result.ok(book.cover!);
    } else {
      final folder = item as Folder;
      if (folder.covers.firstOrNull == null) {
        final result = await getFolderCover(folder.id, 0);
        switch (result) {
          case Ok():
            folder.covers.add(result.value);
            _databaseService.updateFolder(folder);
          case Error():
            return Result.error(result.error);
        }
      } else if (folder.covers.first != '') {
        if (!File(folder.covers.first!).existsSync()) {
          final result = await getFolderCover(folder.id, 0);
          switch (result) {
            case Ok():
              folder.covers.add(result.value);
              _databaseService.updateFolder(folder);
            case Error():
              return Result.error(result.error);
          }
        }
      }
      return Result.ok(folder.covers.first!);
    }
  }
}
