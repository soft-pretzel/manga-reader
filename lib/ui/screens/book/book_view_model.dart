import 'package:flutter/foundation.dart';

import '../../../data/models/book.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class BookViewModel extends ChangeNotifier {
  final String _bookId;
  final LibraryRepository _libraryRepository;

  BookViewModel({required this._bookId, required this._libraryRepository}) {
    fetchMetadata = Command0(_fetchMetadata);
    load = Command0(_load)..execute();
    markAsFinished = Command1(_markAsFinished);
    markAsUnread = Command1(_markAsUnread);
    openLink = Command1(_openLink);
  }

  late final Command0 fetchMetadata;
  late final Command0 load;
  late final Command1<void, String> markAsFinished;
  late final Command1<void, String> markAsUnread;
  late final Command1<void, Uri> openLink;

  late Book _book;

  Book get book => _book;

  Future<Result<void>> _fetchMetadata() async {
    final result = await _libraryRepository.fetchMetadata(_book);
    switch (result) {
      case Ok():
        _load();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _load() async {
    try {
      Future.wait([_loadBook()]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadBook() async {
    try {
      final result = await _libraryRepository.getBook(_bookId);
      switch (result) {
        case Ok():
          _book = result.value;
          notifyListeners();
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _markAsFinished(String id) async {
    final result = await _libraryRepository.markAsFinished(id);
    switch (result) {
      case Ok():
        _load();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _markAsUnread(String id) async {
    final result = await _libraryRepository.markAsUnread(id);
    switch (result) {
      case Ok():
        _load();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _openLink(Uri uri) async {
    final result = await _libraryRepository.openLink(uri);
    switch (result) {
      case Ok():
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
