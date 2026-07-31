import 'package:flutter/foundation.dart';

import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class ReaderViewModel extends ChangeNotifier {
  ReaderViewModel({required this._bookId, required this._libraryRepository}) {
    loadBook = Command0(_loadBook)..execute();
    loadPage = Command0(_loadPage)..execute();
    updateBook = Command1(_updateBook);
  }

  final String _bookId;
  final LibraryRepository _libraryRepository;

  late final Command0 loadBook;
  late final Command0 loadPage;
  late final Command1<void, int> updateBook;

  int _currentPage = 0;
  List<String> _pages = [];

  int get currentPage => _currentPage;
  List<String> get pages => _pages;

  Future<Result<void>> _loadBook() async {
    final result = await _libraryRepository.openBook(_bookId);
    switch (result) {
      case Ok():
        _pages = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadPage() async {
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
        _libraryRepository.updateBook(book);
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
