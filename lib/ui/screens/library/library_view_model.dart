import 'package:material_ui/material_ui.dart';

import '../../../data/models/book.dart';
import '../../../data/models/folder.dart';
import '../../../data/models/library_old.dart';
// import '../../../data/models/server/server.dart';
import '../../../data/models/settings.dart';
import '../../../data/repositories/library_repository_old.dart';
import '../../../data/repositories/server_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/services/database/database.dart';
import '../../../data/services/database/tables.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({
    required this._libraryRepository,
    this._id,
    this._path,
    required this._settingsRepository,
    required this._serverRepository,
  }) {
    addLocalFolder = Command0(_addLocalFolder);
    addServer = Command1(_addServer);
    clearSnackBar = Command0(_clearSnackBar);
    deleteLocalFolder = Command1(_deleteLocalFolder);
    disableSelectionMode = Command0(_disableSelectionMode);
    load = Command0(_load)..execute();
    markAsFinished = Command1(_markAsFinished);
    markAsUnread = Command1(_markAsUnread);
    parseFolder = Command1(_parseFolder);
    toggleSelect = Command1(_toggleSelect);
    selectAll = Command0(_selectAll);
    setLibraryDisplayMode = Command1(_setLibraryDisplayMode);
    setLibraryFilter = Command1(_setLibraryFilter);
    setLibrarySort = Command1(_setLibarySort);
    setLibrarySpacing = Command1(_setLibrarySpacing);
  }

  final LibraryRepository _libraryRepository;
  final String? _id;
  final String? _path;
  final SettingsRepository _settingsRepository;
  final ServerRepository _serverRepository;

  late final Command0 addLocalFolder;
  late final Command1<
    void,
    (String apiKey, String name, ServerType type, String url)
  >
  addServer;
  late final Command0 clearSnackBar;
  late final Command1<void, Folder> deleteLocalFolder;
  late final Command0 disableSelectionMode;
  late final Command0 load;
  late final Command1<void, Book> markAsFinished;
  late final Command1<void, Book> markAsUnread;
  late final Command1<void, Folder> parseFolder;
  late final Command1<void, int> toggleSelect;
  late final Command0 selectAll;
  late final Command1<void, ReadingStatus> setLibraryFilter;
  late final Command1<void, LibraryDisplayMode> setLibraryDisplayMode;
  late final Command1<void, LibrarySort> setLibrarySort;
  late final Command1<void, LibrarySpacing> setLibrarySpacing;

  double? _coverAspectRatio;
  bool _isSelectionMode = false;
  // late Library _library;
  late LibraryDisplayMode _libraryDisplayMode;
  List<ReadingStatus> _libraryFilter = [];
  late LibrarySort _librarySort;
  late LibrarySpacing _librarySpacing;
  late ReadingDirection _readingDirection;
  List<bool> _selected = [];
  int _selectedBookCount = 0;
  int _selectedFolderCount = 0;
  final List<Server> _servers = [];
  String? _snackBar;
  String _title = 'Library';

  double? get coverAspectRatio => _coverAspectRatio;
  bool get isSelectionMode => _isSelectionMode;
  // Library get library => _library;
  LibraryDisplayMode get libraryDisplayMode => _libraryDisplayMode;
  List<ReadingStatus> get libraryFilter => _libraryFilter;
  LibrarySort get librarySort => _librarySort;
  LibrarySpacing get librarySpacing => _librarySpacing;
  ReadingDirection get readingDirection => _readingDirection;
  List<bool> get selected => _selected;
  int get selectedBookCount => _selectedBookCount;
  int get selectedFolderCount => _selectedFolderCount;
  List<Server> get servers => _servers;
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
          _snackBar = 'Folder \'${existingFolder.name}\' already added';
        } else {
          final folder = await _libraryRepository.saveNewFolder(newFolder);
          // _library.items.add(folder);
          await _disableSelectionMode();
          _snackBar = 'Added new folder \'${folder.name}\'';
          notifyListeners();
          _parseFolder(folder);
        }
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _addServer(
    (String, String, ServerType, String) input,
  ) async {
    final (apiKey, name, type, url) = input;
    final server = Server(
      apiKey: apiKey,
      dateAdded: DateTime.now(),
      name: name,
      type: type,
      url: url,
    );
    return await _serverRepository.addServer(server);
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
      // _loadLibrary();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _disableSelectionMode() async {
    try {
      _isSelectionMode = false;
      // _selected = List.filled(_library.items.length, false);
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Future<void> _getFolderCovers(Folder folder) async {
  //   final library = await _libraryRepository.getLibrary(folder);
  //   library.sort(_librarySort);
  //   final items = library.items;
  //   for (int i = 0; i < folder.covers.length; i++) {
  //     if (items.elementAtOrNull(i) == null) {
  //       folder.covers[i] = '';
  //     } else {
  //       if (items[i].runtimeType == Book) {
  //         var item = items[i] as Book;
  //         if (item.cover == null) {
  //           item = await _libraryRepository.parseBook(item, null);
  //         }
  //         folder.covers[i] = item.cover;
  //         notifyListeners();
  //       } else {
  //         final item = items[i] as Folder;
  //         await _getFolderCovers(item);
  //         folder.covers[i] = item.covers.first;
  //         notifyListeners();
  //       }
  //     }
  //   }
  // }

  void _getSelectedCount() {
    _selectedBookCount = 0;
    _selectedFolderCount = 0;
    for (final (index, selected) in _selected.indexed) {
      if (selected) {
        // if (_library.items[index].runtimeType == Book) {
        //   _selectedBookCount++;
        // } else {
        //   _selectedFolderCount++;
        // }
      }
    }
  }

  Future<Result<void>> _load() async {
    try {
      _libraryDisplayMode = await _settingsRepository.getLibraryDisplayMode();
      _libraryFilter = await _settingsRepository.getLibraryFilter();
      _librarySort = await _settingsRepository.getLibrarySort();
      _librarySpacing = await _settingsRepository.getLibrarySpacing();
      _readingDirection = await _settingsRepository.getReadingDirection();
      notifyListeners();
      // _loadLibrary();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // Future<void> _loadLibrary() async {
  //   final parent = await _libraryRepository.getParent(_id, _path);
  //   _library = await _libraryRepository.getLibrary(parent);
  //   if (_library.items.isNotEmpty) {
  //     // _library.filter(_libraryFilter);
  //     // _library.sort(_librarySort);
  //     if (_isSelectionMode) _isSelectionMode = false;
  //     _selected = List.filled(_library.items.length, false);
  //     notifyListeners();
  //     for (final (index, item) in _library.items.indexed) {
  //       switch (item.runtimeType) {
  //         case Book:
  //           await _parseBook(index);
  //         case Folder:
  //           await _parseFolder(item as Folder);
  //       }
  //     }
  //   } else {
  //     notifyListeners();
  //   }
  // }

  Future<Result<void>> _markAsFinished(Book book) async {
    try {
      if (book.readingStatus != .finished) {
        book.readingStatus = .finished;
        // _loadLibrary();
        _libraryRepository.updateBook(book);
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _markAsUnread(Book book) async {
    try {
      if (book.readingStatus != .unread) {
        book.readingStatus = .unread;
        // _loadLibrary();
        _libraryRepository.updateBook(book);
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _parseBook(int index) async {
    try {
      // final book = _library.items[index] as Book;
      // final lastModified = await _libraryRepository.getLastModified(book.path);
      // if (book.lastModified != lastModified) {
      //   _library.items[index] = await _libraryRepository.parseBook(
      //     book,
      //     lastModified,
      //   );
      //   notifyListeners();
      // }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _parseFolder(Folder folder) async {
    try {
      // final parentFolder = await _libraryRepository.getParentFolder(folder);
      // if (await _libraryRepository.getFilePermission(parentFolder.path)) {
      final lastModified = await _libraryRepository.getLastModified(
        folder.path,
      );
      if (folder.lastModified != lastModified) {
        await _libraryRepository.parseFolder(folder, lastModified);
        // _loadLibrary();
      }
      // await _getFolderCovers(folder);
      // } else {
      //   _snackBar = 'Can\'t access folder \'${parentFolder.name}\'';
      //   notifyListeners();
      // }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _selectAll() async {
    try {
      _isSelectionMode = true;
      // _selected = List.filled(_library.items.length, true);
      _getSelectedCount();
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
      await _settingsRepository.setLibraryDisplayMode(libraryDisplayMode);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setLibrarySpacing(LibrarySpacing librarySpacing) async {
    try {
      _librarySpacing = librarySpacing;
      notifyListeners();
      await _settingsRepository.setLibrarySpacing(librarySpacing);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setLibraryFilter(ReadingStatus readingStatus) async {
    try {
      if (_libraryFilter.contains(readingStatus)) {
        _libraryFilter.remove(readingStatus);
      } else {
        _libraryFilter.add(readingStatus);
      }
      // _loadLibrary();
      await _settingsRepository.setLibraryFilter(_libraryFilter);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setLibarySort(LibrarySort librarySort) async {
    try {
      _librarySort = librarySort;
      // _loadLibrary();
      await _settingsRepository.setLibrarySort(librarySort);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _toggleSelect(int index) async {
    try {
      _selected[index] = !_selected[index];
      _getSelectedCount();
      if (_selectedBookCount + _selectedFolderCount == 0) {
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
