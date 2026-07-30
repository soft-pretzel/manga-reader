import 'package:flutter/foundation.dart';

import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class ReaderViewModel extends ChangeNotifier {
  ReaderViewModel({required this._bookId, required this._libraryRepository}) {
    load = Command0(_load)..execute();
  }

  final String _bookId;
  final LibraryRepository _libraryRepository;

  List<String> _pages = [];
  List<String> get pages => _pages;

  late final Command0 load;

  Future<Result<void>> _load() async {
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
}
