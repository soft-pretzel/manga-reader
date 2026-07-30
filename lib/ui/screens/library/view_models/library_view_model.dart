import 'package:flutter/foundation.dart';

import '../../../../data/models/library_item.dart';
import '../../../../data/repositories/library_repository.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({required this._libraryRepository}) {
    addFolder = Command0(_addFolder);
    deleteFolder = Command1(_deleteFolder);
    load = Command0(_load)..execute();
  }

  final LibraryRepository _libraryRepository;

  late final Command0 addFolder;
  late final Command1<void, String> deleteFolder;
  late final Command0 load;

  final List<LibraryItem?> _libraryItems = [];
  String? _snackBar;

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
    final result = await _libraryRepository.getLibraryItems(null);
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
}
