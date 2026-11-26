import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:unseal/unseal.dart' as unseal;

import '../models/book.dart';
import '../models/folder.dart';
import '../models/library/library.dart';
import '../models/opds_feed.dart';
import '../models/opds_entry.dart';
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

  Future<Book> getBook(String id) async {
    return await _databaseService.getBook(id);
  }

  Future<bool> getFilePermission(String path) async {
    return await _localStorageService.getFilePermission(path);
  }

  Future<Folder?> getFolderByPath(String path) async {
    return await _databaseService.getFolderByPath(path);
  }

  // Future<List<LibraryItem>> getFolderItems(String? parentId) async {
  //   final List<LibraryItem> items = [];
  //   items.addAll(await _databaseService.getFoldersByParentId(parentId));
  //   if (parentId != null) {
  //     items.addAll(await _databaseService.getBooksByParentId(parentId));
  //   }
  //   return items;
  // }

  Future<Result<List<Book>>> getInProgressBooks() async {
    try {
      final books = await _databaseService.getInProgressBooks();
      return Result.ok(books);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<DateTime> getLastModified(String path) async {
    return await _localStorageService.getLastModified(path);
  }

  // Future<List<Library>> getLibrary() async {
  // }

  // Future<LibraryItem?> getParent(String? id, String? path) async {
  //   if (id != null) {
  //     final folder = await _databaseService.getFolderById(id);
  //     final opds = await _databaseService.getServer(id);
  //     if (opds != null && path != null) {
  //       opds.uri = Uri.parse(
  //         '${opds.uri.scheme}://${opds.uri.host}:${opds.uri.port}$path',
  //       );
  //     }
  //     return folder ?? opds;
  //   }
  //   return null;
  // }

  // Future<Folder> getParentFolder(LibraryItem item) async {
  //   while (item.parentId != null) {
  //     item = await _databaseService.getFolderById(item.parentId!);
  //   }
  //   return item as Folder;
  // }

  Future<OpdsFeed> getServer(String id, String? path) async {
    final server = await _databaseService.getServer(id);
    if (path != null) {
      server!.uri = Uri.parse('${server.uri}/$path');
    }
    final response = await http.get(server!.uri);
    server.feed = unseal.OpdsFeed.parse(response.body);
    return server;
  }

  // Future<List<LibraryItem>> getServerItems(Opds server) async {
  //   server.feed = unseal.OpdsFeed.parse((await http.get(server.uri)).body);
  //   final List<LibraryItem> items = [];
  //   for (final entry in server.feed!.entries) {
  //     final uri = Uri.parse(
  //       '${server.uri.scheme}://${server.uri.host}:${server.uri.port}${entry.links.first.href}',
  //     );
  //     final opds = Opds(
  //       id: server.id,
  //       feed: unseal.OpdsFeed.parse((await http.get(uri)).body),
  //       uri: uri,
  //     );
  //     items.add(opds);
  //   }
  //   return items;
  // }

  // Future<List<OpdsFeed>> getAllServers() async {
  //   final servers = await _databaseService.getServers();
  //   for (final server in servers) {
  //     final response = await http.get(server.uri);
  //     server.feed = unseal.OpdsFeed.parse(response.body);
  //   }
  //   return servers;
  // }

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

  Future<unseal.BookSession> openBook(String path) async {
    return await _localStorageService.getBookSession(path);
  }

  Future<Result<void>> openLink(Uri uri) async {
    try {
      await _utilsService.openLink(uri);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Book> parseBook(Book book, DateTime? lastModified) async {
    final token = RootIsolateToken.instance;
    return await Isolate.run(() async {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token!);
      final session = await _localStorageService.getBookSession(book.path);
      final metadata = session.book.metadata;
      book.aspectRatio = metadata.cover!.width! / metadata.cover!.height!;
      // book.cover = metadata.cover?.bytes;
      book.cover = await _localStorageService.saveBookCover(
        metadata.cover,
        book.id,
      );
      book.description = metadata.description;
      book.format = session.book.format;
      book.isbn = metadata.isbn;
      book.language = metadata.languages.firstOrNull;
      book.lastModified =
          lastModified ?? await _localStorageService.getLastModified(book.path);
      book.pageCount = session.book.files.images.length;
      book.publishYear = metadata.publishedAt?.year;
      book.publisher = metadata.publisher;
      book.series = metadata.series;
      book.seriesIndex = metadata.seriesIndex;
      book.title =
          metadata.title ?? await _localStorageService.getFileName(book.path);
      session.dispose();
      await _databaseService.updateBook(book);
      return book;
    });
  }

  Future<void> parseFolder(Folder folder, DateTime? lastModified) async {
    final files = await _localStorageService.getFiles(folder.path);
    for (final file in files) {
      if (await _localStorageService.isDir(file)) {
        final existingFolder = await _databaseService.getFolderByPath(file);
        if (existingFolder == null) {
          final newFolder = await saveNewFolder(file, parentId: folder.id);
          await parseFolder(newFolder, null);
        }
      } else {
        final existingBook = await _databaseService.getBookByPath(file);
        if (existingBook == null) {
          await saveNewBook(file, folder);
        }
      }
    }
    folder.itemCount = (await _localStorageService.getFiles(folder.path))
        .length;
    folder.lastModified =
        lastModified ?? await _localStorageService.getLastModified(folder.path);
    folder.name = await _localStorageService.getFileName(folder.path);
    await _databaseService.updateFolder(folder);
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

  Future<Book> saveNewBook(String path, Folder folder) async {
    final book = Book(
      id: await _databaseService.generateId(),
      dateAdded: DateTime.now(),
      parentId: folder.id,
      path: path,
      title: await _localStorageService.getFileName(path),
    );
    await _databaseService.insertBook(book);
    return book;
  }

  Future<Folder> saveNewFolder(String path, {String? parentId}) async {
    final folder = Folder(
      id: await _databaseService.generateId(),
      covers: List.filled(3, null),
      dateAdded: DateTime.now(),
      itemCount: (await _localStorageService.getFiles(path)).length,
      parentId: parentId,
      path: path,
      name: await _localStorageService.getFileName(path),
    );
    await _databaseService.insertFolder(folder);
    return folder;
  }

  Future<String?> selectLocalFolder() async {
    return await _localStorageService.pickDirectory();
  }

  Future<void> updateBook(Book book) async {
    await _databaseService.updateBook(book);
  }
}
