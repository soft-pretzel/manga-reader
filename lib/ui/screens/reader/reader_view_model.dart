import 'package:flutter/foundation.dart';
import 'package:manga_reader/data/models/book_model.dart';

import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class ReaderViewModel extends ChangeNotifier {
  ReaderViewModel({required this._bookId, required this._libraryRepository}) {
    load = Command0(_load)..execute();
    getCurrentPage = Command0(_getCurrentPage);
    updateBook = Command1(_updateBook);
  }

  final String _bookId;
  final LibraryRepository _libraryRepository;

  late final Command0 load;
  late final Command0 getCurrentPage;
  late final Command1<void, int> updateBook;

  BookModel? _book;
  int _currentPage = 0;
  List<String> _pages = [];

  BookModel? get book => _book;
  int get currentPage => _currentPage;
  List<String> get pages => _pages;

  Future<Result<void>> _load() async {
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
        _currentPage = result.value.currentPage ?? 0;
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
        if (currentPage + 4 >= _pages.length) {
          book.readingStatus = ReadingStatus.finished;
          _libraryRepository.deleteBookCache(book.id);
        } else if (currentPage == 1) {
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
