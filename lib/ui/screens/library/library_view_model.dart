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
    clearSnackBar = Command0(_clearSnackBar);
    deleteLocalFolder = Command1(_deleteLocalFolder);
    disableSelectionMode = Command0(_disableSelectionMode);
    load = Command0(_load)..execute();
    markAsFinished = Command1(_markAsFinished);
    markAsUnread = Command1(_markAsUnread);
    parseFolder = Command1(_parseFolder);
    toggleSelect = Command1(_toggleSelect);
    selectAll = Command0(_selectAll);
    setDisplayMode = Command1(_setDisplayMode);
    setFilter = Command1(_setFilter);
    setSort = Command1(_setSort);
    setSpacing = Command1(_setSpacing);
  }

  final LibraryRepository _libraryRepository;
  final String? _folderId;
  final SettingsRepository _settingsRepository;

  late final Command0 addLocalFolder;
  late final Command0 clearSnackBar;
  late final Command1<void, Folder> deleteLocalFolder;
  late final Command0 disableSelectionMode;
  late final Command0 load;
  late final Command1<void, Book> markAsFinished;
  late final Command1<void, Book> markAsUnread;
  late final Command1<void, Folder> parseFolder;
  late final Command1<void, int> toggleSelect;
  late final Command0 selectAll;
  late final Command1<void, ReadingStatus> setFilter;
  late final Command1<void, LibraryDisplayMode> setDisplayMode;
  late final Command1<void, LibrarySort> setSort;
  late final Command1<void, LibraryDisplaySpacing> setSpacing;

  double? _coverAspectRatio;
  late LibraryDisplayMode _displayMode;
  List<ReadingStatus> _filter = [];
  bool _isSelectionMode = false;
  late Library _library;
  late ReadingDirection _readingDirection;
  List<bool> _selected = [];
  int _selectedCount = 0;
  String? _snackBar;
  late LibrarySort _sort;
  late LibraryDisplaySpacing _spacing;

  double? get coverAspectRatio => _coverAspectRatio;
  LibraryDisplayMode get displayMode => _displayMode;
  List<ReadingStatus> get filter => _filter;
  bool get isSelectionMode => _isSelectionMode;
  Library get library => _library;
  ReadingDirection get readingDirection => _readingDirection;
  List<bool> get selected => _selected;
  int get selectedCount => _selectedCount;
  String? get snackBar => _snackBar;
  LibrarySort get sort => _sort;
  LibraryDisplaySpacing get spacing => _spacing;

  Future<Result<void>> _addLocalFolder() async {
    try {
      final newFolder = await _libraryRepository.selectLocalFolder();
      if (newFolder == null) {
        _snackBar = 'No folder selected';
      } else {
        final existingFolder = await _libraryRepository.getFolderByPath(
          newFolder,
        );
        if (existingFolder != null) {
          _snackBar = 'Folder \'${existingFolder.title}\' already added';
        } else {
          final folder = await _libraryRepository.saveNewFolder(newFolder);
          _library.items.add(folder);
          notifyListeners();
          _snackBar = 'Added new folder \'${folder.title}\'';
          _parseFolder(folder);
        }
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _clearSnackBar() async {
    try {
      _snackBar = null;
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _deleteLocalFolder(Folder folder) async {
    try {
      await _libraryRepository.deleteLocalFolder(folder);
      _loadLibrary();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _disableSelectionMode() async {
    try {
      _isSelectionMode = false;
      _selected = List.filled(_library.items.length, false);
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> _filterLibrary() async {
    _library.filter(_filter);
    if (_isSelectionMode) _disableSelectionMode();
  }

  Future<void> _getBookCover(Book book) async {
    if (book.cover == null) {
      book.cover = await _libraryRepository.getBookCover(book);
      notifyListeners();
      _libraryRepository.updateBook(book);
    }
  }

  Future<void> _getFolderCovers(Folder folder) async {
    final library = await _libraryRepository.getLibrary(folder.id);
    library.sort(_sort);
    final items = library.items;
    for (int i = 0; i < folder.covers.length; i++) {
      if (items.elementAtOrNull(i) == null) {
        folder.covers[i] = '';
      } else {
        if (items[i].runtimeType == Book) {
          final item = items[i] as Book;
          if (item.cover == null) {
            item.cover = await _libraryRepository.getBookCover(item);
            _libraryRepository.updateBook(item);
          }
          folder.covers[i] = item.cover;
          notifyListeners();
        } else {
          final item = items[i] as Folder;
          await _getFolderCovers(item);
          folder.covers[i] = item.covers.first;
          notifyListeners();
        }
      }
    }
  }

  Future<Result<void>> _load() async {
    try {
      _filter = await _settingsRepository.getFilter();
      _displayMode = await _settingsRepository.getLibraryDisplayMode();
      _sort = await _settingsRepository.getLibrarySort();
      _spacing = await _settingsRepository.getLibraryDisplaySpacing();
      _readingDirection = await _settingsRepository.getReadingDirection();
      _loadLibrary();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> _loadLibrary() async {
    _library = await _libraryRepository.getLibrary(_folderId);
    if (_library.items.isNotEmpty) {
      _library.filter(_filter);
      _library.sort(_sort);
      if (_isSelectionMode) _isSelectionMode = false;
      _selected = List.filled(_library.items.length, false);
      notifyListeners();
      for (final item in _library.items) {
        if (item.runtimeType == Folder) {
          await _getFolderCovers(item as Folder);
        } else {
          await _getBookCover(item as Book);
        }
      }
    } else {
      notifyListeners();
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

  Future<Result<void>> _parseFolder(Folder folder) async {
    try {
      await _libraryRepository.parseFolder(folder);
      _loadLibrary();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _selectAll() async {
    try {
      _isSelectionMode = true;
      _selected = List.filled(_library.items.length, true);
      _selectedCount = _selected.length;
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setDisplayMode(
    LibraryDisplayMode libraryDisplayMode,
  ) async {
    try {
      _displayMode = libraryDisplayMode;
      notifyListeners();
      _settingsRepository.setLibraryDisplayMode(libraryDisplayMode);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setSpacing(
    LibraryDisplaySpacing libraryDisplaySpacing,
  ) async {
    try {
      _spacing = libraryDisplaySpacing;
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
      _loadLibrary();
      _settingsRepository.setFilter(_filter);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setSort(LibrarySort librarySort) async {
    try {
      _sort = librarySort;
      _loadLibrary();
      _settingsRepository.setLibrarySort(librarySort);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
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
