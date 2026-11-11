import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:unseal/unseal.dart' as unseal;

import '../models/book.dart';
import '../models/folder.dart';
import '../models/library.dart';
import '../models/library_item.dart';
import '../services/database_service.dart';
import '../services/local_storage_service.dart';
import '../../utils/result.dart';
import '../services/utils_service.dart';

class LibraryRepository {
  LibraryRepository({
    required this._databaseService,
    required this._localStorageService,
    required this._utilsService,
  });

  final DatabaseService _databaseService;
  final LocalStorageService _localStorageService;
  final UtilsService _utilsService;

  static List<String> comicTypes = ['cbt', 'cbz', 'tar', 'zip'];
  static List<String> imgTypes = ['jpeg', 'jpg', 'png'];

  Future<void> deleteLocalFolder(Folder folder) async {
    _databaseService.deleteFolder(folder.id);
    _localStorageService.clearStorageAccess(folder.path);
    final childFolders = await _databaseService.getFoldersByParentId(folder.id);
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
  }

  Future<Result<void>> fetchMetadata(Book book) async {
    try {
      final uri = Uri.parse(
        'https://openlibrary.org/search.json?title=${book.title.toLowerCase().replaceAll(' ', '+')}&fields=author_name,first_publish_year,id_goodreads,id_librarything,key,language,subject,subtitle,title',
      );
      final result = await _utilsService.makeHttpRequest(uri);
      final doc = result['docs'][0];
      List<String> genres = [];
      for (final String subject in doc['subject']) {
        if (subject.contains('genre')) {
          genres.add(subject.split(':').last);
        }
      }
      book.author = doc['author_name'][0];
      book.goodreads = doc['id_goodreads'].last;
      book.language = doc['language'][0];
      book.libraryThing = doc['id_librarything'].last;
      book.openLibrary = doc['key'];
      book.publishYear = doc['first_publish_year'];
      book.genres = genres;
      book.subtitle = doc['subtitle'];
      book.title = doc['title'];
      await _databaseService.updateBook(book);
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

  Future<Book?> getBookByPath(String path) async {
    return await _databaseService.getBookByPath(path);
  }

  Future<String> getBookCover(Book book) async {
    final cover = await _localStorageService.extractBookCover(
      book.path,
      book.id,
    );
    return cover ?? '';
  }

  Future<unseal.BookSession> getBookSession(String path) async {
    return await _localStorageService.getBookSession(path);
  }

  Future<Folder> getFolder(String id) async {
    return await _databaseService.getFolderById(id);
  }

  Future<Folder?> getFolderByPath(String path) async {
    return await _databaseService.getFolderByPath(path);
  }

  Future<List<String>> getFolderFiles(String path) async {
    return await _localStorageService.getFiles(path);
  }

  Future<List<LibraryItem>> getFolderItems(String? parentId) async {
    final List<LibraryItem> library = [];
    library.addAll(await _databaseService.getFoldersByParentId(parentId));
    if (parentId != null) {
      library.addAll(await _databaseService.getBooksByParentId(parentId));
    }
    return library;
  }

  Future<Result<List<Book>>> getInProgressBooks() async {
    try {
      final books = await _databaseService.getInProgressBooks();
      return Result.ok(books);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Library> getLibrary(String? parentId) async {
    return Library(
      items: await getFolderItems(parentId),
      title: parentId != null ? (await getFolder(parentId)).title : 'Library',
    );
  }

  Future<Result<String>> getName(String path) async {
    try {
      final name = await _localStorageService.getFileName(path);
      return Result.ok(name);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<int> getPageCount(Book book) async {
    return await _localStorageService.getPageCount(book.path);
  }

  Future<bool> isDir(String path) async {
    return await _localStorageService.isDir(path);
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

  Future<unseal.BookSession> openBook(String id) async {
    final book = await _databaseService.getBook(id);
    return await _localStorageService.getBookSession(book.path);
  }

  Future<Result<void>> openLink(Uri uri) async {
    try {
      await _utilsService.openLink(uri);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> parseFolder(Folder folder) async {
    final files = await _localStorageService.getFiles(folder.path);
    for (final file in files) {
      if (await _localStorageService.isDir(file)) {
        final existingFolder = await _databaseService.getFolderByPath(file);
        if (existingFolder == null) {
          final newFolder = await saveNewFolder(file, parentId: folder.id);
          await parseFolder(newFolder);
        }
      } else {
        final existingBook = await _databaseService.getBookByPath(file);
        if (existingBook == null) {
          await saveNewBook(file, folder);
        }
      }
    }
    // final List<Library> existingItems = [];
    // existingItems.addAll(
    //   await _databaseService.getFoldersByParentId(folder.id),
    // );
    // existingItems.addAll(
    //   await _databaseService.getBooksByParentId(folder.id),
    // );
    // for (final existingItem in existingItems) {
    //   if (!items.contains(existingItem.path)) {
    //     if (existingItem.runtimeType == Folder) {
    //       await _databaseService.deleteFolder(existingItem.id);
    //     } else {
    //       final existingBook = existingItem as Book;
    //       await _databaseService.deleteBook(existingItem.id);
    //       if (existingBook.cover != null && existingBook.cover != '') {
    //         await _localStorageService.deleteFile(existingItem.cover!);
    //       }
    //     }
    //   }
    // }
  }

  Future<String?> saveCover(unseal.BookCover? cover, String id) async {
    if (cover != null) {
      final cache = await _localStorageService.getCoversCache();
      final file = File(
        '${cache.path}${Platform.pathSeparator}$id.${cover.fileExtension}',
      );
      await file.writeAsBytes(cover.bytes, flush: true);
      return file.path;
    } else {
      return null;
    }
  }

  Future<Folder> saveNewFolder(String path, {String? parentId}) async {
    final folder = Folder(
      id: await _databaseService.generateId(),
      covers: List.filled(3, null),
      dateAdded: DateTime.now(),
      itemCount: (await _localStorageService.getFiles(path)).length,
      parentId: parentId,
      path: path,
      title: await _localStorageService.getFileName(path),
    );
    await _databaseService.insertFolder(folder);
    return folder;
  }

  Future<Book> saveNewBook(String path, Folder folder) async {
    final token = RootIsolateToken.instance;
    return await Isolate.run(() async {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token!);
      final session = await _localStorageService.getBookSession(path);
      final metadata = session.book.metadata;
      final book = Book(
        id: await _databaseService.generateId(),
        author: metadata.authors.firstOrNull,
        dateAdded: DateTime.now(),
        description: metadata.description,
        format: session.book.format,
        isbn: metadata.isbn,
        language: metadata.languages.firstOrNull,
        pageCount: session.book.files.images.length,
        parentId: folder.id,
        path: path,
        publishYear: metadata.publishedAt?.year,
        publisher: metadata.publisher,
        series: metadata.series ?? folder.title,
        seriesIndex: metadata.seriesIndex,
        title: metadata.title ?? await _localStorageService.getFileName(path),
      );
      session.dispose();
      await _databaseService.insertBook(book);
      return book;
    });
  }

  Future<String?> selectLocalFolder() async {
    return await _localStorageService.pickDirectory();
  }

  Future<void> updateBook(Book book) async {
    await _databaseService.updateBook(book);
  }

  Future<void> updateFolder(Folder folder) async {
    await _databaseService.updateFolder(folder);
  }
}
