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

  List<Book?> _inProgressBooks = [];

  List<Book?> get inProgressBooks => _inProgressBooks;

  Future<Result<void>> _load() async {
    final result = await _libraryRepository.getInProgressBooks();
    switch (result) {
      case Ok():
        _inProgressBooks = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
