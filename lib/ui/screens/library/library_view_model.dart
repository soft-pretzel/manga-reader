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
    disableSelectionMode = Command0(_disableSelectionMode);
    getBookCover = Command1(_getBookCover);
    getFolderCover1 = Command1(_getFolderCover1);
    getFolderCover2 = Command1(_getFolderCover2);
    getFolderCover3 = Command1(_getFolderCover3);
    load = Command0(_load)..execute();
    markAsFinished = Command1(_markAsFinished);
    markAsUnread = Command1(_markAsUnread);
    parseLocalFolder = Command1(_parseLocalFolder);
    toggleSelect = Command1(_toggleSelect);
    selectAll = Command0(_selectAll);
    setFilter = Command1(_setFilter);
    setLibraryDisplayMode = Command1(_setLibraryDisplayMode);
    setLibraryDisplaySpacing = Command1(_setLibraryDisplaySpacing);
    setLibrarySort = Command1(_setLibrarySort);
  }

  final LibraryRepository _libraryRepository;
  final String? _folderId;
  final SettingsRepository _settingsRepository;

  late final Command0 addLocalFolder;
  late final Command1<void, Folder> deleteLocalFolder;
  late final Command0 disableSelectionMode;
  late final Command1<void, Book> getBookCover;
  late final Command1<void, Folder> getFolderCover1;
  late final Command1<void, Folder> getFolderCover2;
  late final Command1<void, Folder> getFolderCover3;
  late final Command0 load;
  late final Command1<void, Book> markAsFinished;
  late final Command1<void, Book> markAsUnread;
  late final Command1<void, Folder> parseLocalFolder;
  late final Command1<void, int> toggleSelect;
  late final Command0 selectAll;
  late final Command1<void, ReadingStatus> setFilter;
  late final Command1<void, LibraryDisplayMode> setLibraryDisplayMode;
  late final Command1<void, LibraryDisplaySpacing> setLibraryDisplaySpacing;
  late final Command1<void, LibrarySort> setLibrarySort;

  double? _coverAspectRatio;
  List<ReadingStatus> _filter = [];
  bool _isSelectionMode = false;
  List<Library> _library = [];
  late LibraryDisplayMode _libraryDisplayMode;
  late LibraryDisplaySpacing _libraryDisplaySpacing;
  late LibrarySort _librarySort;
  late ReadingDirection _readingDirection;
  List<bool> _selected = [];
  int _selectedCount = 0;
  String _title = 'Library';

  double? get coverAspectRatio => _coverAspectRatio;
  List<ReadingStatus> get filter => _filter;
  bool get isSelectionMode => _isSelectionMode;
  List<Library> get library => _library;
  LibraryDisplayMode get libraryDisplayMode => _libraryDisplayMode;
  LibraryDisplaySpacing get libraryDisplaySpacing => _libraryDisplaySpacing;
  LibrarySort get librarySort => _librarySort;
  ReadingDirection get readingDirection => _readingDirection;
  List<bool> get selected => _selected;
  int get selectedCount => _selectedCount;
  String get title => _title;

  Future<Result<void>> _addLocalFolder() async {
    final result = await _libraryRepository.addLocalFolder();
    switch (result) {
      case Ok():
        if (result.value != null) {
          _parseLocalFolder(result.value!);
          _library.add(result.value!);
          notifyListeners();
        }
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _deleteLocalFolder(Folder folder) async {
    final result = await _libraryRepository.deleteLocalFolder(folder);
    switch (result) {
      case Ok():
        _loadLibrary();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _disableSelectionMode() async {
    try {
      _isSelectionMode = false;
      _selected = List.filled(_library.length, false);
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> _filterLibrary() async {
    await _loadLibrary();
    if (_filter.isNotEmpty) {
      _library.removeWhere((item) {
        if (item.runtimeType == Book) {
          final book = item as Book;
          return !_filter.contains(book.readingStatus);
        } else {
          return false;
        }
      });
    }
    _disableSelectionMode();
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
    if (!parseLocalFolder.running) {
      final result = await _libraryRepository.getFolderCover(folder.id, 0);
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

  Future<Result<void>> _getFolderCover2(Folder folder) async {
    if (!parseLocalFolder.running) {
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
    }
    return Result.ok(null);
  }

  Future<Result<void>> _getFolderCover3(Folder folder) async {
    if (!parseLocalFolder.running) {
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
    }
    return Result.ok(null);
  }

  Future<Result<void>> _load() async {
    try {
      await Future.wait([_loadFilter(), _loadLibrarySort()]);
      await Future.wait([
        _loadFolder(),
        _loadLibrary(),
        _loadLibraryDisplayMode(),
        _loadLibraryDisplaySpacing(),
        _loadReadingDirection(),
      ]);
      await Future.wait([_disableSelectionMode(), _filterLibrary()]);
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
        if (_library.isNotEmpty) {
          await _sortLibrary();
        }
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadLibraryDisplayMode() async {
    final result = await _settingsRepository.getLibraryDisplayMode();
    switch (result) {
      case Ok():
        _libraryDisplayMode = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadLibraryDisplaySpacing() async {
    final result = await _settingsRepository.getLibraryDisplaySpacing();
    switch (result) {
      case Ok():
        _libraryDisplaySpacing = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadFilter() async {
    final result = await _settingsRepository.getFilter();
    switch (result) {
      case Ok():
        _filter = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadLibrarySort() async {
    final result = await _settingsRepository.getLibrarySort();
    switch (result) {
      case Ok():
        _librarySort = result.value;
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
          _title = result.value.title;
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

  Future<Result<void>> _markAsFinished(Book book) async {
    try {
      book.readingStatus = .finished;
      _filterLibrary();
      notifyListeners();
      _libraryRepository.updateBook(book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _markAsUnread(Book book) async {
    try {
      book.readingStatus = .unread;
      notifyListeners();
      _libraryRepository.updateBook(book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _parseLocalFolder(Folder folder) async {
    final result = await _libraryRepository.parseLocalFolder(folder);
    switch (result) {
      case Ok():
        _loadLibrary();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _selectAll() async {
    try {
      _isSelectionMode = true;
      _selected = List.filled(_library.length, true);
      _selectedCount = _selected.length;
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setLibraryDisplayMode(
    LibraryDisplayMode libraryDisplayMode,
  ) async {
    try {
      _libraryDisplayMode = libraryDisplayMode;
      notifyListeners();
      _settingsRepository.setLibraryDisplayMode(libraryDisplayMode);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setLibraryDisplaySpacing(
    LibraryDisplaySpacing libraryDisplaySpacing,
  ) async {
    try {
      _libraryDisplaySpacing = libraryDisplaySpacing;
      notifyListeners();
      _settingsRepository.setLibraryDisplaySpacing(libraryDisplaySpacing);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setFilter(ReadingStatus filter) async {
    try {
      if (_filter.contains(filter)) {
        _filter.remove(filter);
      } else {
        _filter.add(filter);
      }
      await _filterLibrary();
      notifyListeners();
      _settingsRepository.setFilter(_filter);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setLibrarySort(LibrarySort librarySort) async {
    try {
      _librarySort = librarySort;
      await _sortLibrary();
      notifyListeners();
      _settingsRepository.setLibrarySort(librarySort);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> _sortLibrary() async {
    switch (_librarySort) {
      case .alphabetical:
        if (_library.firstOrNull?.title.replaceAll(RegExp(r'[^0-9]'), '') !=
            '') {
          _library.sort(
            (a, b) => int.parse(
              a.title.replaceAll(RegExp(r'[^0-9]'), ''),
            ).compareTo(int.parse(b.title.replaceAll(RegExp(r'[^0-9]'), ''))),
          );
        } else {
          _library.sort((a, b) => a.title.compareTo(b.title));
        }
      case .alphabeticalReverse:
        if (_library.first.title.replaceAll(RegExp(r'[^0-9]'), '') != '') {
          _library.sort(
            (b, a) => int.parse(
              a.title.replaceAll(RegExp(r'[^0-9]'), ''),
            ).compareTo(int.parse(b.title.replaceAll(RegExp(r'[^0-9]'), ''))),
          );
        } else {
          _library.sort((b, a) => a.title.compareTo(b.title));
        }
      case .dateAdded:
        _library.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
      case .dateAddedReverse:
        _library.sort((b, a) => a.dateAdded.compareTo(b.dateAdded));
      case .fileSize:
      case .fileSizeReverse:
    }
    _disableSelectionMode();
  }

  Future<Result<void>> _toggleSelect(int index) async {
    try {
      _selected[index] = !_selected[index];
      _selectedCount = 0;
      for (final selected in _selected) {
        if (selected) _selectedCount++;
      }
      if (_selectedCount == 0) {
        _isSelectionMode = false;
      } else {
        _isSelectionMode = true;
      }
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
