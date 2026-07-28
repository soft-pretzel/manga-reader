import 'package:flutter/foundation.dart';

import '../../../data/models/library_item.dart';
import '../../../data/repositories/book_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this._libraryRepository}) {
    load = Command0(_load)..execute();
    setCurrentBook = Command1(_setCurrentBook);
  }

  final BookRepository _libraryRepository;
  late final Command0 load;
  late final Command1<void, int> setCurrentBook;
  final List<BookItem> _inProgressBooks = [];

  List<BookItem> get inProgressBooks => _inProgressBooks;

  Future<Result<void>> _load() async {
    _inProgressBooks.clear();
    final booksResult = await _libraryRepository.getBooks();
    switch (booksResult) {
      case Ok():
        final books = booksResult.value;
        if (books.isNotEmpty) {
          for (final book in books) {
            if (book!.readingStatus == ReadingStatus.inProgress) {
              _inProgressBooks.add(book);
              notifyListeners();
            }
          }
        }
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(booksResult.error);
    }
  }

  Future<Result<void>> _setCurrentBook(int id) async {
    final result = await _libraryRepository.setCurrentBook(id);
    switch (result) {
      case Ok<void>():
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
