import 'package:flutter/foundation.dart';

import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class ReaderViewModel extends ChangeNotifier {
  ReaderViewModel({required this._libraryRepository}) {
    openBook = Command0(_openBook)..execute();
  }

  final LibraryRepository _libraryRepository;

  List<String>? _pages;
  List<String>? get pages => _pages;

  void clearPages() {
    _pages = null;
    notifyListeners();
  }

  late final Command0 openBook;

  Future<Result<void>> _openBook() async {
    final currentBookResult = await _libraryRepository.getCurrentBook();
    switch (currentBookResult) {
      case Ok<String?>():
        final currentBook = currentBookResult.value;
        if (currentBook != null) {
          final extractComicResult = await _libraryRepository.openComic(
            currentBook,
          );
          switch (extractComicResult) {
            case Ok<List<String>>():
              _pages = extractComicResult.value;
              notifyListeners();
              return Result.ok(null);
            case Error():
              notifyListeners();
              return Result.error(extractComicResult.error);
          }
        }
        notifyListeners();
        return Result.ok(null);
      case Error():
        notifyListeners();
        return Result.error(currentBookResult.error);
    }
  }
}
