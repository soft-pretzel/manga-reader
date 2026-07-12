import 'package:flutter/foundation.dart';

import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({required this._libraryRepository}) {
    addFolder = Command0(_addFolder);
    deleteFolder = Command1(_deleteFolder);
    loadFolders = Command0(_loadFolders)..execute();
  }

  final LibraryRepository _libraryRepository;

  List<String>? _folders;
  List<String>? get folders => _folders;

  late final Command0 addFolder;
  late final Command1<void, String> deleteFolder;
  late final Command0 loadFolders;

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

  Result<void> handleResult(Result<List<String>> result) {
    switch (result) {
      case Ok<List<String>>():
        _folders = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error<List<String>>():
        return Result.error(result.error);
    }
  }
}
