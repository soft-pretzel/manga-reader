import 'package:flutter/foundation.dart';

import '../../../data/models/library_item.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({this._folderId, required this._libraryRepository}) {
    addFolder = Command0(_addFolder);
    deleteFolder = Command1(_deleteFolder);
    load = Command0(_load)..execute();
    loadFolderName = Command0(_loadFolderName)..execute();
  }

  final String? _folderId;
  final LibraryRepository _libraryRepository;

  late final Command0 addFolder;
  late final Command1<void, String> deleteFolder;
  late final Command0 load;
  late final Command0 loadFolderName;

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

  Future<Result<void>> _load() async {
    final result = await _libraryRepository.getLibraryItems(_folderId);
    switch (result) {
      case Ok():
        for (final item in result.value) {
          if (!_libraryItems
              .map((libraryItem) => libraryItem?.id)
              .contains(item.id)) {
            _libraryItems.add(item);
          }
          notifyListeners();
        }
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadFolderName() async {
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
}
