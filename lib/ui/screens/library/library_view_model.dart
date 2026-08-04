import 'package:flutter/foundation.dart';

import '../../../data/models/book_item.dart';
import '../../../data/models/library_item.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({this._folderId, required this._libraryRepository}) {
    addFolder = Command0(_addFolder);
    deleteFolder = Command1(_deleteFolder);
    getFolderName = Command0(_getFolderName)..execute();
    load = Command0(_load)..execute();
    setReadingStatus = Command1(_setReadingStatus);
    // update = Command0(_update);
  }

  final String? _folderId;
  final LibraryRepository _libraryRepository;

  late final Command0 addFolder;
  late final Command1<void, String> deleteFolder;
  late final Command0 getFolderName;
  late final Command0 load;
  late final Command1<void, String> setReadingStatus;
  // late final Command0 update;

  String _title = 'Library';
  final List<LibraryItem?> _libraryItems = [];
  String? _snackBar;

  String get title => _title;
  List<LibraryItem?> get libraryItems => _libraryItems;
  String? get snackBar => _snackBar;

  Future<Result<void>> _addFolder() async {
    final result = await _libraryRepository.addFolder();
    switch (result) {
      case Ok():
        if (result.value == null) {
          _snackBar = 'No folder selected';
        } else if (result.value == '') {
          _snackBar = 'Folder already added';
        } else {
          _load();
          _snackBar = 'Added folder \'${result.value}\'';
        }
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _deleteFolder(String id) async {
    final result = await _libraryRepository.deleteFolder(id);
    switch (result) {
      case Ok():
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _getFolderName() async {
    if (_folderId != null) {
      final result = await _libraryRepository.getFolder(_folderId);
      switch (result) {
        case Ok():
          _title = result.value.name;
          notifyListeners();
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    }
    return Result.ok(null);
  }

  Future<Result<void>> _load() async {
    final result = await _libraryRepository.getLibraryItems(_folderId);
    switch (result) {
      case Ok():
        _libraryItems.clear();
        _libraryItems.addAll(result.value);
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _setReadingStatus(String id) async {
    final result = await _libraryRepository.getBook(id);
    switch (result) {
      case Ok():
        final book = result.value;
        book.readingStatus = ReadingStatus.inProgress;
        _libraryRepository.updateBook(book);
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
