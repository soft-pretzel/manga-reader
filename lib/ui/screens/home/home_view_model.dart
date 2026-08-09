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

  final List<Book> _inProgressBooks = [];

  List<Book> get inProgressBooks => _inProgressBooks;

  Future<Result<void>> _load() async {
    _inProgressBooks.clear();
    final booksResult = await _libraryRepository.getInProgressBooks();
    switch (booksResult) {
      case Ok():
        final books = booksResult.value;
        if (books.isNotEmpty) {
          for (final book in books) {
            _inProgressBooks.add(book!);
            notifyListeners();
          }
        }
        return Result.ok(null);
      case Error():
        return Result.error(booksResult.error);
    }
  }
}
