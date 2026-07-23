import 'package:flutter/foundation.dart';

import '../../../data/models/book.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this._libraryRepository}) {
    load = Command0(_load)..execute();
  }

  final LibraryRepository _libraryRepository;

  late final Command0 load;

  Book? _currentBook;
  final List<Book>? _inProgressBooks = [];
  Book? get currentBook => _currentBook;
  List<Book>? get inProgressBooks => _inProgressBooks;

  Future<Result<void>> _load() async {
    final booksResult = await _libraryRepository.getBooks();
    switch (booksResult) {
      case Ok<List<Book>?>():
        final books = booksResult.value;
        if (books != null) {
          for (final book in books) {
            if (book.readingStatus == ReadingStatus.inProgress) {
              _inProgressBooks?.add(book);
              notifyListeners();
            }
          }
        }
        return Result.ok(null);
      case Error():
        return Result.error(booksResult.error);
    }
  }
}
