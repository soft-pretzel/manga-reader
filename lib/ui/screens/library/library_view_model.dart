import 'dart:io';

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
    // getBookCover = Command1(_getBookCover);
    load = Command0(_load)..execute();
    markAsFinished = Command1(_markAsFinished);
    markAsUnread = Command1(_markAsUnread);
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
  late final Command0 clearSnackBar;
  late final Command1<void, Folder> deleteLocalFolder;
  late final Command0 disableSelectionMode;
  // late final Command1<void, Book> getBookCover;
  late final Command0 load;
  late final Command1<void, Book> markAsFinished;
  late final Command1<void, Book> markAsUnread;
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
  String? _snackBar;
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
  String? get snackBar => _snackBar;
  String get title => _title;

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
          _library.add(folder);
          notifyListeners();
          _snackBar = 'Added new folder \'${folder.title}\'';
          _loadFolder(folder);
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
    final result = await _libraryRepository.deleteLocalFolder(folder);
    switch (result) {
      case Ok():
        _library.removeWhere((item) => item == folder);
        notifyListeners();
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
    if (_isSelectionMode) _disableSelectionMode();
  }

  Future<void> _getFolderCovers(Folder folder) async {
    folder.sort(_librarySort);
    for (int i = 0; i < folder.covers.length; i++) {
      if (folder.items.elementAtOrNull(i) == null) {
        folder.covers[i] = '';
      } else {
        if (folder.items[i].runtimeType == Book) {
          final item = folder.items[i] as Book;
          if (item.cover == null) {
            item.cover = await _libraryRepository.getBookCover(item);
            _libraryRepository.updateBook(item);
          }
          folder.covers[i] = item.cover;
          notifyListeners();
        } else {
          final item = folder.items[i] as Folder;
          item.sort(_librarySort);
          await _getFolderCovers(item);
          folder.covers[i] = item.covers.first;
          notifyListeners();
        }
      }
    }
  }

  Future<Result<void>> _load() async {
    try {
      await Future.wait([
        _loadFilter(),
        _loadLibraryDisplayMode(),
        _loadLibraryDisplaySpacing(),
        _loadLibrarySort(),
        _loadReadingDirection(),
        _loadTitle(),
      ]);
      _loadLibrary();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<void> _loadBook(Book book) async {
    if (book.cover == null || book.pageCount == null) {
      final session = await _libraryRepository.openBook(book.id);
      if (book.cover == null) {
        book.cover = await _libraryRepository.saveCover(
          session.book.metadata.cover,
          book.id,
        );
        notifyListeners();
      }
      if (book.pageCount == null) {
        book.pageCount = session.book.files.images.length;
        notifyListeners();
      }
      _libraryRepository.updateBook(book);
      session.dispose();
    }
  }

  Future<void> _loadLibrary() async {
    _library = await _libraryRepository.getLibrary(_folderId);
    if (_library.isNotEmpty) {
      await _filterLibrary();
      await _sortLibrary();
      _selected = List.filled(_library.length, false);
      notifyListeners();
      for (final item in _library) {
        if (item.runtimeType == Folder) {
          await _loadFolder(item as Folder);
        } else {
          await _loadBook(item as Book);
        }
      }
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

  Future<void> _loadFolder(Folder folder) async {
    folder.items = await _libraryRepository.getFolderItems(folder);
    notifyListeners();
    await _getFolderCovers(folder);
    _libraryRepository.updateFolder(folder);
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

  Future<Result<void>> _loadTitle() async {
    try {
      if (_folderId != null) {
        final folder = await _libraryRepository.getFolder(_folderId);
        _title = folder.title;
        notifyListeners();
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
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
        _library.sort((a, b) => _sortAlphabetically(a, b));
      case .alphabeticalReverse:
        _library.sort((b, a) => _sortAlphabetically(a, b));
      case .dateAdded:
        _library.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
      case .dateAddedReverse:
        _library.sort((b, a) => a.dateAdded.compareTo(b.dateAdded));
      case .lastRead:
      case .lastReadReverse:
    }
    for (final item in _library) {
      if (item.runtimeType == Folder) {
        final folder = item as Folder;
        folder.sort(_librarySort);
        await _getFolderCovers(folder);
      }
    }
    if (_isSelectionMode) _disableSelectionMode();
  }

  int _sortAlphabetically(Library a, Library b) {
    if (a.title.replaceAll(RegExp(r'[^0-9]'), '') != '') {
      return int.parse(
        a.title.replaceAll(RegExp(r'[^0-9]'), ''),
      ).compareTo(int.parse(b.title.replaceAll(RegExp(r'[^0-9]'), '')));
    } else {
      return a.title.compareTo(b.title);
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
