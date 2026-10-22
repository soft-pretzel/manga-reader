import 'package:flutter/foundation.dart';

import '../../../data/models/library.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({required this._libraryRepository, this._folderId}) {
    addLocalFolder = Command0(_addLocalFolder);
    deleteLocalFolder = Command1(_deleteLocalFolder);
    load = Command0(_load)..execute();
  }

  final LibraryRepository _libraryRepository;
  final String? _folderId;

  late final Command0 addLocalFolder;
  late final Command1<void, String> deleteLocalFolder;
  late final Command0 load;

  List<Library> _library = [];
  String _title = 'Library';

  List<Library> get library => _library;
  String get title => _title;

  Future<Result<void>> _addLocalFolder() async {
    final result = await _libraryRepository.addLocalFolder();
    switch (result) {
      case Ok():
        await _loadLibrary();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _deleteLocalFolder(String id) async {
    final result = await _libraryRepository.deleteLocalFolder(id);
    switch (result) {
      case Ok():
        await _loadLibrary();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _load() async {
    try {
      await Future.wait([_loadFolder(), _loadLibrary()]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadLibrary() async {
    final result = await _libraryRepository.getLibrary(_folderId);
    switch (result) {
      case Ok():
        _library = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadFolder() async {
    if (_folderId != null) {
      final result = await _libraryRepository.getFolder(_folderId);
      switch (result) {
        case Ok():
          _title = result.value.name;
          notifyListeners();
        case Error():
          return Result.error(result.error);
      }
    }
    return Result.ok(null);
  }
}
