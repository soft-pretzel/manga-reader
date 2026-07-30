import 'package:flutter/foundation.dart';
import 'package:manga_reader/data/repositories/library_repository.dart';

import '../../../data/models/book_item.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this._libraryRepository}) {
    load = Command0(_load)..execute();
  }

  final LibraryRepository _libraryRepository;

  late final Command0 load;

  final List<BookItem> _inProgressBooks = [];

  List<BookItem> get inProgressBooks => _inProgressBooks;

  Future<Result<void>> _load() async {
    _inProgressBooks.clear();
    final booksResult = await _libraryRepository.getAllBooks();
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
}
