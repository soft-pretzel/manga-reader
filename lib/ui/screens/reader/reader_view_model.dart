import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../data/models/book.dart';
import '../../../data/models/settings.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class ReaderViewModel extends ChangeNotifier {
  final String _bookId;
  final LibraryRepository _libraryRepository;
  final SettingsRepository _settingsRepository;

  ReaderViewModel({
    required this._bookId,
    required this._libraryRepository,
    required this._settingsRepository,
  }) {
    goToFirstPage = Command0(_goToFirstPage);
    goToLastPage = Command0(_goToLastPage);
    load = Command0(_load)..execute();
    setCurrentPage = Command1(_setCurrentPage);
    setReadingStatus = Command0(_setReadingStatus);
    updateBook = Command0(_updateBook);
  }

  late final Command0 goToFirstPage;
  late final Command0 goToLastPage;
  late final Command0 load;
  late final Command1<void, int> setCurrentPage;
  late final Command0 setReadingStatus;
  late final Command0 updateBook;

  late final Book _book;
  late CarouselController _carouselController;
  late int _currentPage;
  final _curve = Curves.easeInOut;
  final _duration = Duration(milliseconds: 300);
  late final bool _ereaderMode;
  late final PageController _pageController;
  List<Uint8List?> _pages = [];
  late ReadingDirection _readingDirection;
  late ReadingMode _readingMode;

  Book get book => _book;
  CarouselController get carouselController => _carouselController;
  int get currentPage => _currentPage;
  Curve get curve => _curve;
  Duration get duration => _duration;
  bool get ereaderMode => _ereaderMode;
  PageController get pageController => _pageController;
  List<Uint8List?> get pages => _pages;
  ReadingDirection get readingDirection => _readingDirection;
  ReadingMode get readingMode => _readingMode;

  Future<Result<void>> _goToFirstPage() async {
    try {
      if (_ereaderMode) {
        _pageController.jumpToPage(0);
      } else {
        _pageController.animateToPage(0, duration: _duration, curve: _curve);
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _goToLastPage() async {
    try {
      if (_ereaderMode) {
        _pageController.jumpToPage(_book.pageCount! - 1);
      } else {
        _pageController.animateToPage(
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
      _book = await _libraryRepository.getBook(_bookId);
      _currentPage = _book.currentPage;
      _ereaderMode = await _settingsRepository.getEreaderMode();
      _carouselController = CarouselController(
        initialItem: (_currentPage / 2).round() - 1,
      );
      _pageController = PageController(
        initialPage: _currentPage - 1,
        keepPage: false,
      );
      _pages = List.filled(_book.pageCount!, null);
      _readingDirection = await _settingsRepository.getReadingDirection();
      _readingMode = await _settingsRepository.getReadingMode();
      notifyListeners();
      _loadPages();
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

  Future<Result<void>> _setCurrentPage(int value) async {
    try {
      _currentPage = value;
      _carouselController = CarouselController(
        initialItem: (_currentPage / 2).round() - 2,
      );
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setReadingStatus() async {
    try {
      if (_book.currentPage + 4 >= _book.pageCount!) {
        _book.readingStatus = .finished;
      } else if (_book.currentPage == 2) {
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

  Future<Result<void>> _updateBook() async {
    try {
      _book.currentPage = _currentPage;
      _book.lastRead = DateTime.now();
      _libraryRepository.updateBook(_book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
