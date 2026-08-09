import 'package:flutter/foundation.dart';

import '../../../data/models/book.dart';
import '../../../data/models/reading_direction.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class ReaderViewModel extends ChangeNotifier {
  ReaderViewModel({required this._bookId, required this._libraryRepository}) {
    load = Command0(_load)..execute();
    getCurrentPage = Command0(_getCurrentPage);
    getReadingDirection = Command0(_getReadingDirection);
    updateBook = Command1(_updateBook);
    setReadingDirection = Command1(_setReadingDirection);
    setReadingStatus = Command0(_setReadingStatus);
  }

  final String _bookId;
  final LibraryRepository _libraryRepository;

  late final Command0 load;
  late final Command0 getCurrentPage;
  late final Command0 getReadingDirection;
  late final Command1<void, int> updateBook;
  late final Command1<void, ReadingDirection> setReadingDirection;
  late final Command0 setReadingStatus;

  Book? _book;
  late int currentPage;
  List<String> _pages = [];
  late ReadingDirection readingDirection;

  Book? get book => _book;
  List<String> get pages => _pages;

  Future<Result<void>> _load() async {
    _getReadingDirection();
    final pagesResult = await _libraryRepository.openBook(_bookId);
    switch (pagesResult) {
      case Ok():
        _pages = pagesResult.value;
        notifyListeners();
        final bookResult = await _libraryRepository.getBook(_bookId);
        switch (bookResult) {
          case Ok():
            _book = bookResult.value;
            notifyListeners();
            return Result.ok(null);
          case Error():
            return Result.error(bookResult.error);
        }
      case Error():
        return Result.error(pagesResult.error);
    }
  }

  Future<Result<void>> _getCurrentPage() async {
    final result = await _libraryRepository.getBook(_bookId);
    switch (result) {
      case Ok():
        currentPage = result.value.currentPage ?? 0;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _getReadingDirection() async {
    final result = await _libraryRepository.getReadingDirection();
    switch (result) {
      case Ok():
        readingDirection = result.value ?? ReadingDirection.leftToRight;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _updateBook(int currentPage) async {
    final result = await _libraryRepository.getBook(_bookId);
    switch (result) {
      case Ok():
        final book = result.value;
        book.currentPage = currentPage;
        book.lastRead = DateTime.now();
        _libraryRepository.updateBook(book);
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _setReadingDirection(
    ReadingDirection readingStatus,
  ) async {
    final result = await _libraryRepository.setReadingDirection(readingStatus);
    switch (result) {
      case Ok():
        await _getReadingDirection();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _setReadingStatus() async {
    final result = await _libraryRepository.getBook(_bookId);
    switch (result) {
      case Ok():
        final book = result.value;
        book.currentPage = currentPage;
        book.lastRead = DateTime.now();
        if (currentPage + 4 >= _pages.length) {
          book.readingStatus = ReadingStatus.finished;
          _libraryRepository.deleteBookCache(book.id);
        } else if (currentPage == 0) {
          book.readingStatus = ReadingStatus.unread;
          _libraryRepository.deleteBookCache(book.id);
        } else {
          book.readingStatus = ReadingStatus.inProgress;
        }
        _libraryRepository.updateBook(book);
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
