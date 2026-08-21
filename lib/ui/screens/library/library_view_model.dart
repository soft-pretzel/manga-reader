import 'package:flutter/foundation.dart';

import '../../../data/models/library.dart';
import '../../../data/models/series.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({this._seriesId, required this._libraryRepository}) {
    getSeriesItemCount = Command1(_getSeriesItemCount);
    getThumbnail = Command1(_getThumbnail);
    getTitle = Command0(_getTitle);
    load = Command0(_load)..execute();
    scanFolder = Command0(_scanFolder);
  }

  final String? _seriesId;
  final LibraryRepository _libraryRepository;

  late final Command1<void, Series> getSeriesItemCount;
  late final Command1<void, Library> getThumbnail;
  late final Command0 getTitle;
  late final Command0 load;
  late final Command0 scanFolder;

  List<Library?> _library = [];
  String _title = 'Library';

  List<Library?> get library => _library;
  String get title => _title;

  Future<Result<void>> _load() async {
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

  Future<Result<void>> _getThumbnail(Library item) async {
    final result = await _libraryRepository.getThumbnail(item);
    switch (result) {
      case Ok():
        item.thumbnail = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
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
