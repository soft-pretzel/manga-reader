import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../data/models/book.dart';
import '../../../data/models/library.dart';
import '../../../data/models/series.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({
    required this._libraryRepository,
    this._seriesId,
    required this._settingsRepository,
  }) {
    getSeriesItemCount = Command1(_getSeriesItemCount);
    getTitle = Command0(_getTitle);
    load = Command0(_load)..execute();
    loadThumbnails = Command0(_loadThumbnails);
    markAsFinished = Command1(_markAsFinished);
    markAsUnread = Command1(_markAsUnread);
    scanFolder = Command0(_scanFolder);
  }

  final LibraryRepository _libraryRepository;
  final String? _seriesId;
  final SettingsRepository _settingsRepository;

  late final Command1<void, Series> getSeriesItemCount;
  late final Command0 getTitle;
  late final Command0 load;
  late final Command0 loadThumbnails;
  late final Command1<void, Book> markAsFinished;
  late final Command1<void, Book> markAsUnread;
  late final Command0 scanFolder;

  late bool _animations;
  List<Library?> _library = [];
  String _title = 'Library';

  bool get animations => _animations;
  List<Library?> get library => _library;
  String get title => _title;

  Future<Result<void>> _load() async {
    try {
      await _loadLibrary();
      Future.wait([_loadAnimations()]);
      _loadThumbnails();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadAnimations() async {
    final result = await _settingsRepository.getAnimations();
    switch (result) {
      case Ok():
        _animations = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadLibrary() async {
    final result = await _libraryRepository.getLibrary(_seriesId);
    switch (result) {
      case Ok():
        _library = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadThumbnails() async {
    if (_library.isNotEmpty) {
      for (final item in _library) {
        if (item!.thumbnail == null ||
            (item.thumbnail != null &&
                File(item.thumbnail!).existsSync() == false)) {
          final result = await _libraryRepository.getThumbnail(item);
          switch (result) {
            case Ok():
              item.thumbnail = result.value;
              notifyListeners();
            case Error():
              return Result.error(result.error);
          }
        }
      }
    }
    return Result.ok(null);
  }

  Future<Result<void>> _getSeriesItemCount(Series series) async {
    final result = await _libraryRepository.getSeriesBookCount(series);
    switch (result) {
      case Ok():
        series.bookCount = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _getTitle() async {
    if (_seriesId != null) {
      final result = await _libraryRepository.getSeriesName(_seriesId);
      switch (result) {
        case Ok():
          _title = result.value;
          notifyListeners();
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    }
    return Result.ok(null);
  }

  Future<Result<void>> _markAsFinished(Book book) async {
    try {
      book.readingStatus = .finished;
      notifyListeners();
      _libraryRepository.deleteBookCache(book.id);
      _libraryRepository.updateBook(book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _markAsUnread(Book book) async {
    try {
      book.readingStatus = .unread;
      notifyListeners();
      _libraryRepository.deleteBookCache(book.id);
      _libraryRepository.updateBook(book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _scanFolder() async {
    final result = await _libraryRepository.scanFolder();
    switch (result) {
      case Ok():
        _load();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
