import 'package:flutter/foundation.dart';

import '../../../data/models/book.dart';
import '../../../data/models/settings.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required this._libraryRepository,
    required this._settingsRepository,
  }) {
    load = Command0(_load)..execute();
    markAsFinished = Command1(_markAsFinished);
  }

  final LibraryRepository _libraryRepository;
  final SettingsRepository _settingsRepository;

  late final Command0 load;
  late final Command1<void, String> markAsFinished;

  List<Book> _inProgressBooks = [];
  late ReadingDirection _readingDirection;

  List<Book> get inProgressBooks => _inProgressBooks;
  ReadingDirection get readingDirection => _readingDirection;

  Future<Result<void>> _load() async {
    try {
      _readingDirection = await _settingsRepository.getReadingDirection();
      await _loadInProgressBooks();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadInProgressBooks() async {
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

  Future<Result<void>> _markAsFinished(String id) async {
    final result = await _libraryRepository.markAsFinished(id);
    switch (result) {
      case Ok():
        await _load();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
