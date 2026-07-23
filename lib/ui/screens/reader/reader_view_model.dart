import 'package:flutter/foundation.dart';

import '../../../data/models/book.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class ReaderViewModel extends ChangeNotifier {
  ReaderViewModel({required this._libraryRepository}) {
    openBook = Command0(_openBook)..execute();
  }

  final LibraryRepository _libraryRepository;

  List<String> _pages = [];
  List<String> get pages => _pages;

  late final Command0 openBook;

  Future<Result<void>> _openBook() async {
    final currentBookResult = await _libraryRepository.getCurrentBook();
    switch (currentBookResult) {
      case Ok<Book>():
        final currentBook = currentBookResult.value;
        final openComicResult = await _libraryRepository.openComic(
          currentBook.id,
        );
        switch (openComicResult) {
          case Ok<List<String>>():
            _pages = openComicResult.value;
            currentBook.readingStatus = ReadingStatus.inProgress;
            await _libraryRepository.updateBook(currentBook);
            notifyListeners();
            return Result.ok(null);
          case Error():
            notifyListeners();
            return Result.error(openComicResult.error);
        }
      case Error():
        notifyListeners();
        return Result.error(currentBookResult.error);
    }
  }
}
