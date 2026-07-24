import 'package:flutter/foundation.dart';

import '../../../data/models/book.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this._libraryRepository}) {
    load = Command0(_load)..execute();
    setCurrentBook = Command1(_setCurrentBook);
  }

  final LibraryRepository _libraryRepository;
  late final Command0 load;
  late final Command1<void, String> setCurrentBook;
  final List<Book> _inProgressBooks = [];

  List<Book> get inProgressBooks => _inProgressBooks;

  Future<Result<void>> _load() async {
    final booksResult = await _libraryRepository.getBooks();
    switch (booksResult) {
      case Ok<List<Book>?>():
        final books = booksResult.value;
        if (books != null) {
          for (final book in books) {
            if (book.readingStatus == ReadingStatus.inProgress) {
              _inProgressBooks.add(book);
              notifyListeners();
            }
          }
        }
        return Result.ok(null);
      case Error():
        return Result.error(booksResult.error);
    }
  }

  Future<Result<void>> _setCurrentBook(String id) async {
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
