import 'package:flutter/foundation.dart';

import '../../../data/models/library.dart';
import '../../../data/models/settings.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({
    required this._libraryRepository,
    this._folderId,
    required this._settingsRepository,
  }) {
    addLocalFolder = Command0(_addLocalFolder);
    deleteLocalFolder = Command1(_deleteLocalFolder);
    load = Command0(_load)..execute();
    markAsFinished = Command1(_markAsFinished);
    markAsUnread = Command1(_markAsUnread);
    setLibraryDisplayDensity = Command1(_setLibraryDisplayDensity);
  }

  final LibraryRepository _libraryRepository;
  final String? _folderId;
  final SettingsRepository _settingsRepository;

  late final Command0 addLocalFolder;
  late final Command1<void, String> deleteLocalFolder;
  late final Command0 load;
  late final Command1<void, String> markAsFinished;
  late final Command1<void, String> markAsUnread;
  late final Command1<void, LibraryDisplayDensity> setLibraryDisplayDensity;

  List<dynamic> _library = [];
  late LibraryDisplayDensity _libraryDisplayDensity;
  late ReadingDirection _readingDirection;
  String _title = 'Library';

  List<dynamic> get library => _library;
  LibraryDisplayDensity get libraryDisplayDensity => _libraryDisplayDensity;
  ReadingDirection get readingDirection => _readingDirection;
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
      await Future.wait([
        _loadFolder(),
        _loadLibrary(),
        _loadLibraryDisplayDensity(),
        _loadReadingDirection(),
      ]);
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

  Future<Result<void>> _loadLibraryDisplayDensity() async {
    final result = await _settingsRepository.getLibraryDisplayDensity();
    switch (result) {
      case Ok():
        _libraryDisplayDensity = result.value;
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

  Future<Result<void>> _loadReadingDirection() async {
    final result = await _settingsRepository.getReadingDirection();
    switch (result) {
      case Ok():
        _readingDirection = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _markAsFinished(String id) async {
    final result = await _libraryRepository.markAsFinished(id);
    switch (result) {
      case Ok():
        await _loadLibrary();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _markAsUnread(String id) async {
    final result = await _libraryRepository.markAsUnread(id);
    switch (result) {
      case Ok():
        await _loadLibrary();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _setLibraryDisplayDensity(
    LibraryDisplayDensity libraryDisplayDensity,
  ) async {
    try {
      _libraryDisplayDensity = libraryDisplayDensity;
      notifyListeners();
      _settingsRepository.setLibraryDisplayDensity(libraryDisplayDensity);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
