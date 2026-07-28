import 'package:flutter/foundation.dart';

import '../../../../data/models/library_item.dart';
import '../../../../data/repositories/book_repository.dart';
import '../../../../data/repositories/folder_repository.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({
    // required this._bookRepository,
    required this._folderRepository,
  }) {
    load = Command0(_load)..execute();
    addFolder = Command0(_addFolder);
    deleteFolder = Command1(_deleteFolder);
    // loadBooks = Command0(_loadBooks);
    // setCurrentBook = Command1(_setCurrentBook);
  }

  // final BookRepository _bookRepository;
  final FolderRepository _folderRepository;

  late final Command0 load;
  late final Command0 addFolder;
  late final Command1<bool, int> deleteFolder;
  late final Command0 loadBooks;
  late final Command1<void, String> openBook;
  late final Command1<void, String> setCurrentBook;

  final List<LibraryItem?> _libraryItems = [];
  String? _snackBar;

  List<LibraryItem?> get libraryItems => _libraryItems;
  String? get snackBar => _snackBar;

  Future<Result<void>> _load() async {
    final result = await _folderRepository.getLibraryItems(null);
    switch (result) {
      case Ok():
        for (final item in result.value) {
          if (!(_libraryItems
                  .map((libraryItem) => libraryItem?.id)
                  .contains(item.id) &&
              _libraryItems
                  .map((libraryItem) => libraryItem?.name)
                  .contains(item.name))) {
            _libraryItems.add(item);
          }
          notifyListeners();
        }
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<FolderItem?>> _addFolder() async {
    final result = await _folderRepository.addFolder();
    switch (result) {
      case Ok():
        if (result.value != null) {
          _load();
          _snackBar = 'Added folder \'${result.value!.name}\'';
        } else {
          _snackBar = 'No folder added';
        }
        notifyListeners();
        return Result.ok(result.value);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<bool>> _deleteFolder(int id) async {
    final result = await _folderRepository.deleteFolder(id);
    switch (result) {
      case Ok():
        return Result.ok(result.value);
      case Error():
        return Result.error(result.error);
    }
  }

  //   Future<Result<void>> _loadFolders() async {
  //     final result = await _bookRepository.getFolders();
  //     return handleResult(result);
  //   }

  //   Future<Result<void>> _loadBooks() async {
  //     final result = await _bookRepository.getBooks();
  //     switch (result) {
  //       case Ok():
  //         _books = result.value;
  //         notifyListeners();
  //         return Result.ok(null);
  //       case Error():
  //         return Result.error(result.error);
  //     }
  //   }

  //   Future<Result<void>> _setCurrentBook(String id) async {
  //     final result = await _bookRepository.setCurrentBook(id);
  //     switch (result) {
  //       case Ok<void>():
  //         notifyListeners();
  //         return Result.ok(null);
  //       case Error():
  //         return Result.error(result.error);
  //     }
  //   }

  //   Result<void> handleResult(Result<List<String>> result) {
  //     switch (result) {
  //       case Ok<List<String>>():
  //         _folders = result.value;
  //         notifyListeners();
  //         return Result.ok(null);
  //       case Error():
  //         return Result.error(result.error);
  //     }
  //   }
}
