import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../../../data/models/book.dart';
import '../../../data/models/settings.dart';
import '../../../data/repositories/library_repository_old.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class ReaderViewModel extends ChangeNotifier {
  final String? _bookId;
  final LibraryRepository _libraryRepository;
  final SettingsRepository _settingsRepository;
  final String? _streamPath;

  ReaderViewModel({
    this._bookId,
    required this._libraryRepository,
    required this._settingsRepository,
    this._streamPath,
  }) {
    goToFirstPage = Command0(_goToFirstPage);
    goToLastPage = Command0(_goToLastPage);
    load = Command0(_load)..execute();
    setReadingStatus = Command0(_setReadingStatus);
    setUndo = Command1(_setUndo);
    updateBook = Command1(_updateBook);
  }

  late final Command0 goToFirstPage;
  late final Command0 goToLastPage;
  late final Command0 load;
  late final Command0 setReadingStatus;
  late final Command1<void, List<int>> setUndo;
  late final Command1<void, int> updateBook;

  late final Book _book;
  final _curve = Curves.easeInOut;
  final _duration = Duration(milliseconds: 300);
  late final bool _ereaderMode;
  late final PageController _mainPageController;
  late PageController _menuPageController;
  List<Uint8List?> _pages = [];
  late ReadingDirection _readingDirection;
  late ReadingMode _readingMode;
  List<int> _undo = [];
  late double _zoom;

  Book get book => _book;
  Curve get curve => _curve;
  Duration get duration => _duration;
  bool get ereaderMode => _ereaderMode;
  PageController get mainPageController => _mainPageController;
  PageController get menuPageController => _menuPageController;
  List<Uint8List?> get pages => _pages;
  ReadingDirection get readingDirection => _readingDirection;
  ReadingMode get readingMode => _readingMode;
  List<int> get undo => _undo;
  double get zoom => _zoom;

  Future<Result<void>> _goToFirstPage() async {
    try {
      if (_ereaderMode) {
        _mainPageController.jumpToPage(0);
      } else {
        _mainPageController.animateToPage(
          0,
          duration: _duration,
          curve: _curve,
        );
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _goToLastPage() async {
    try {
      if (_ereaderMode) {
        _mainPageController.jumpToPage(_book.pageCount! - 1);
      } else {
        _mainPageController.animateToPage(
          _book.pageCount! - 1,
          duration: _duration,
          curve: _curve,
        );
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _load() async {
    try {
      SystemChrome.setEnabledSystemUIMode(.immersiveSticky);
      if (_bookId != null) {
        _book = await _libraryRepository.getBook(_bookId);
        _ereaderMode = await _settingsRepository.getEreaderMode();
        _mainPageController = PageController(
          initialPage: _book.currentPage - 1,
          keepPage: false,
        );
        _pages = List.filled(_book.pageCount!, null);
        _readingDirection = await _settingsRepository.getReadingDirection();
        _readingMode = await _settingsRepository.getReadingMode();
        _zoom = await _settingsRepository.getZoom();
        notifyListeners();
        _loadPages();
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadPages() async {
    try {
      final session = await _libraryRepository.openBook(_book.path);
      final pages = session.book.files.images;
      Future<void> loadPage(int index) async {
        _pages[index] = await session.loadResource(pages[index].path);
        notifyListeners();
      }

      int i = _book.currentPage - 1;
      int j = i + 1;
      final List<Future> futures = [];
      while (futures.length < pages.length) {
        if (i >= 0) {
          futures.add(loadPage(i));
          i--;
        }
        if (j < pages.length) {
          futures.add(loadPage(j));
          j++;
        }
      }
      await Future.wait(futures);
      session.dispose();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setReadingStatus() async {
    try {
      if (_book.currentPage + 4 >= _book.pageCount!) {
        _book.readingStatus = .finished;
      } else if (_book.currentPage == 1) {
        _book.readingStatus = .unread;
      } else {
        _book.readingStatus = .inProgress;
      }
      _libraryRepository.updateBook(_book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setUndo(List<int> undo) async {
    try {
      _undo = undo;
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _updateBook(int currentPage) async {
    try {
      _book.currentPage = currentPage;
      _book.lastRead = DateTime.now();
      _libraryRepository.updateBook(_book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
