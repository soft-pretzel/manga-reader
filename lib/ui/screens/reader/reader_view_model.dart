import 'package:flutter/foundation.dart';

import '../../../data/models/book.dart';
import '../../../data/models/settings.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class ReaderViewModel extends ChangeNotifier {
  ReaderViewModel({
    required this._bookId,
    required this._libraryRepository,
    required this._settingsRepository,
  }) {
    load = Command0(_load)..execute();
    loadBook = Command0(_loadBook);
    setReadingDirection = Command1(_setReadingDirection);
    setReadingMode = Command1(_setReadingMode);
    setReadingStatus = Command0(_setReadingStatus);
    toggleAnimations = Command0(_toggleAnimations);
    updateBook = Command1(_updateBook);
  }

  final String _bookId;
  final LibraryRepository _libraryRepository;
  final SettingsRepository _settingsRepository;

  late final Command0 load;
  late final Command0 loadBook;
  late final Command1<void, ReadingDirection> setReadingDirection;
  late final Command1<void, ReadingMode> setReadingMode;
  late final Command0 setReadingStatus;
  late final Command0 toggleAnimations;
  late final Command1<void, int> updateBook;

  late bool _animations;
  late Book _book;
  late List<String> _pages = [];
  late ReadingDirection _readingDirection;
  late ReadingMode _readingMode;
  late double _zoom;

  bool get animations => _animations;
  Book get book => _book;
  List<String> get pages => _pages;
  ReadingDirection get readingDirection => _readingDirection;
  ReadingMode get readingMode => _readingMode;
  double get zoom => _zoom;

  Future<Result<void>> _load() async {
    try {
      await Future.wait([
        _loadAnimations(),
        _loadPages(),
        _loadReadingDirection(),
        _loadReadingMode(),
        _loadZoom(),
      ]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadAnimations() async {
    final result = await _settingsRepository.getAnimations();
    switch (result) {
      case Ok():
        _animations = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadBook() async {
    final result = await _libraryRepository.getBook(_bookId);
    switch (result) {
      case Ok():
        _book = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadPages() async {
    final result = await _libraryRepository.openBook(_bookId);
    switch (result) {
      case Ok():
        _pages = result.value;
        notifyListeners();
        if (_book.length == null) {
          _book.length = _pages.length;
          _libraryRepository.updateBook(book);
        }
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

  Future<Result<void>> _loadReadingMode() async {
    final result = await _settingsRepository.getReadingMode();
    switch (result) {
      case Ok():
        _readingMode = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadZoom() async {
    final result = await _settingsRepository.getZoom();
    switch (result) {
      case Ok():
        _zoom = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _updateBook(int currentPage) async {
    try {
      _book.currentPage = currentPage;
      _book.lastRead = .now();
      notifyListeners();
      _libraryRepository.updateBook(_book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _toggleAnimations() async {
    try {
      _animations = !_animations;
      notifyListeners();
      _settingsRepository.toggleAnimations();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setReadingDirection(
    ReadingDirection readingDirection,
  ) async {
    try {
      _readingDirection = readingDirection;
      notifyListeners();
      _settingsRepository.setReadingDirection(readingDirection);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setReadingMode(ReadingMode readingMode) async {
    try {
      _readingMode = readingMode;
      notifyListeners();
      _settingsRepository.setReadingMode(readingMode);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setReadingStatus() async {
    try {
      if (_book.currentPage + 4 >= _pages.length) {
        _book.readingStatus = .finished;
        _libraryRepository.deleteBookCache(_book.id);
      } else if (_book.currentPage == 1) {
        _book.readingStatus = .unread;
        _libraryRepository.deleteBookCache(_book.id);
      } else {
        _book.readingStatus = .inProgress;
      }
      _libraryRepository.updateBook(_book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
