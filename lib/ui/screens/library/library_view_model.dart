import 'package:flutter/foundation.dart';

import '../../../data/models/book.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({required this._libraryRepository}) {
    addFolder = Command0(_addFolder);
    deleteFolder = Command1(_deleteFolder);
    loadFolders = Command0(_loadFolders)..execute();
    loadBooks = Command0(_loadBooks);
    // openBook = Command1(_openBook);
    setCurrentBook = Command1(_setCurrentBook);
  }

  final LibraryRepository _libraryRepository;

  List<String>? _folders;
  List<Book>? _books;
  // List<String>? _pages;
  List<String>? get folders => _folders;
  List<Book>? get books => _books;
  // List<String>? get pages => _pages;

  late final Command0 addFolder;
  late final Command1<void, String> deleteFolder;
  late final Command0 loadFolders;
  late final Command0 loadBooks;
  late final Command1<void, String> openBook;
  late final Command1<void, String> setCurrentBook;

  Future<Result<void>> _addFolder() async {
    final result = await _libraryRepository.addFolder();
    return handleResult(result);
  }

  Future<Result<void>> _deleteFolder(String folder) async {
    final result = await _libraryRepository.deleteFolder(folder);
    return handleResult(result);
  }

  Future<Result<void>> _loadFolders() async {
    final result = await _libraryRepository.getFolders();
    return handleResult(result);
  }

  Future<Result<void>> _loadBooks() async {
    final result = await _libraryRepository.getBooks();
    switch (result) {
      case Ok<List<Book>?>():
        _books = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  // Future<Result<void>> _openBook(String id) async {
  //   final result = await _libraryRepository.openComic(id);
  //   switch (result) {
  //     case Ok<List<String>>():
  //       _pages = result.value;
  //       notifyListeners();
  //       return Result.ok(null);
  //     case Error():
  //       return Result.error(result.error);
  //   }
  // }

  Future<Result<void>> _setCurrentBook(String id) async {
    final result = await _libraryRepository.setCurrentBook(id);
    switch (result) {
      case Ok<void>():
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Result<void> handleResult(Result<List<String>> result) {
    switch (result) {
      case Ok<List<String>>():
        _folders = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
