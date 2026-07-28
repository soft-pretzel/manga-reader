import 'package:flutter/foundation.dart';

import '../../../../data/models/library_item.dart';
import '../../../../data/repositories/folder_repository.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class FolderViewModel extends ChangeNotifier {
  FolderViewModel({required this._folderRepository, required this._folderId}) {
    load = Command0(_load)..execute();
    loadFolderName = Command0(_loadFolderName)..execute();
  }

  final FolderRepository _folderRepository;
  final int _folderId;

  late final Command0 load;
  late final Command0 loadFolderName;

  String _folderName = '';
  final List<LibraryItem?> _libraryItems = [];

  String get folderName => _folderName;
  List<LibraryItem?> get libraryItems => _libraryItems;

  Future<Result<void>> _load() async {
    final result = await _folderRepository.getLibraryItems(_folderId);
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

  Future<Result<void>> _loadFolderName() async {
    final result = await _folderRepository.getFolder(_folderId);
    switch (result) {
      case Ok():
        _folderName = result.value.name;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
