import 'package:flutter/foundation.dart';

import '../../../data/models/book.dart';
import '../../../data/models/folder.dart';
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
    getBookCover = Command1(_getBookCover);
    getFolderCover1 = Command1(_getFolderCover1);
    getFolderCover2 = Command1(_getFolderCover2);
    getFolderCover3 = Command1(_getFolderCover3);
    load = Command0(_load)..execute();
    markAsFinished = Command1(_markAsFinished);
    markAsUnread = Command1(_markAsUnread);
    parseLocalFolder = Command1(_parseLocalFolder);
    setLibraryDisplayDensity = Command1(_setLibraryDisplayDensity);
  }

  final LibraryRepository _libraryRepository;
  final String? _folderId;
  final SettingsRepository _settingsRepository;

  late final Command0 addLocalFolder;
  late final Command1<void, String> deleteLocalFolder;
  late final Command1<void, Book> getBookCover;
  late final Command1<void, Folder> getFolderCover1;
  late final Command1<void, Folder> getFolderCover2;
  late final Command1<void, Folder> getFolderCover3;
  late final Command0 load;
  late final Command1<void, String> markAsFinished;
  late final Command1<void, String> markAsUnread;
  late final Command1<void, Folder> parseLocalFolder;
  late final Command1<void, LibraryDisplayDensity> setLibraryDisplayDensity;

  List<Library> _library = [];
  late LibraryDisplayDensity _libraryDisplayDensity;
  late ReadingDirection _readingDirection;
  String _title = 'Library';

  List<Library> get library => _library;
  LibraryDisplayDensity get libraryDisplayDensity => _libraryDisplayDensity;
  ReadingDirection get readingDirection => _readingDirection;
  String get title => _title;

  Future<Result<void>> _addLocalFolder() async {
    final result = await _libraryRepository.addLocalFolder();
    switch (result) {
      case Ok():
        if (result.value != null) {
          _parseLocalFolder(result.value!);
          _loadLibrary();
        }
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

  Future<Result<void>> _getBookCover(Book book) async {
    final result = await _libraryRepository.getBookCover(book.path, book.id);
    switch (result) {
      case Ok():
        book.cover = result.value;
        notifyListeners();
        _libraryRepository.updateBook(book);
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _getFolderCover1(Folder folder) async {
    final result = await _libraryRepository.getFolderCover(folder.id, 0);
    switch (result) {
      case Ok():
        folder.covers.add(result.value);
        notifyListeners();
        _libraryRepository.updateFolder(folder);
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _getFolderCover2(Folder folder) async {
    if (folder.covers.elementAtOrNull(0) != null) {
      final result = await _libraryRepository.getFolderCover(folder.id, 1);
      switch (result) {
        case Ok():
          folder.covers.add(result.value);
          notifyListeners();
          _libraryRepository.updateFolder(folder);
        case Error():
          return Result.error(result.error);
      }
    }
    return Result.ok(null);
  }

  Future<Result<void>> _getFolderCover3(Folder folder) async {
    if (folder.covers.elementAtOrNull(1) != null) {
      final result = await _libraryRepository.getFolderCover(folder.id, 2);
      switch (result) {
        case Ok():
          folder.covers.add(result.value);
          notifyListeners();
          _libraryRepository.updateFolder(folder);
        case Error():
          return Result.error(result.error);
      }
    }
    return Result.ok(null);
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

  Future<Result<void>> _parseLocalFolder(Folder folder) async {
    final result = await _libraryRepository.parseLocalFolder(folder);
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
