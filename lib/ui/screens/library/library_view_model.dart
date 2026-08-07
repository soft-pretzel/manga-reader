import 'package:flutter/foundation.dart';

import '../../../data/models/book_model.dart';
import '../../../data/models/library_model.dart';
import '../../../data/models/series_model.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({this._seriesId, required this._libraryRepository}) {
    getBookThumbnails = Command0(_getBookThumbnails);
    getSeriesBookCount = Command0(_getSeriesBookCount);
    getSeriesThumbnails = Command0(_getSeriesThumbnails);
    getTitle = Command0(_getTitle);
    load = Command0(_load)..execute();
    refresh = Command0(_refresh);
  }

  final String? _seriesId;
  final LibraryRepository _libraryRepository;

  late final Command0 getBookThumbnails;
  late final Command0 getSeriesBookCount;
  late final Command0 getSeriesThumbnails;
  late final Command0 getTitle;
  late final Command0 load;
  late final Command0 refresh;

  final List<LibraryModel?> _library = [];
  String _title = 'Library';

  List<LibraryModel?> get libraryItems => _library;
  String get title => _title;

  Future<Result<void>> _load() async {
    final result = await _libraryRepository.getLibrary(_seriesId);
    switch (result) {
      case Ok():
        _library.clear();
        _library.addAll(result.value);
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _getBookThumbnails() async {
    if (_library.isNotEmpty) {
      for (final item in _library) {
        if (item.runtimeType == BookModel) {
          final book = item as BookModel;
          if (book.thumbnail == null) {
            final result = await _libraryRepository.getBookThumbnail(book);
            switch (result) {
              case Ok():
                book.thumbnail = result.value;
                notifyListeners();
              case Error():
                return Result.error(result.error);
            }
          }
        }
      }
    }
    return Result.ok(null);
  }

  Future<Result<void>> _getSeriesBookCount() async {
    if (_library.isNotEmpty) {
      for (final item in _library) {
        if (item.runtimeType == SeriesModel) {
          final series = item as SeriesModel;
          final result = await _libraryRepository.getSeriesBookCount(series);
          switch (result) {
            case Ok():
              series.bookCount = result.value;
              notifyListeners();
            case Error():
              return Result.error(result.error);
          }
        }
      }
    }
    return Result.ok(null);
  }

  Future<Result<void>> _getSeriesThumbnails() async {
    if (_library.isNotEmpty) {
      for (final item in _library) {
        if (item.runtimeType == SeriesModel) {
          final series = item as SeriesModel;
          if (series.thumbnail == null) {
            final result = await _libraryRepository.getSeriesThumbnail(series);
            switch (result) {
              case Ok():
                series.thumbnail = result.value;
                notifyListeners();
              case Error():
                return Result.error(result.error);
            }
          }
        }
      }
    }
    return Result.ok(null);
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

  Future<Result<void>> _refresh() async {
    final result = await _libraryRepository.scanFolder();
    switch (result) {
      case Ok():
        await _load();
        await _getSeriesBookCount();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
