import 'package:flutter/foundation.dart';

import '../../../data/models/library_model.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({this._seriesId, required this._libraryRepository}) {
    load = Command0(_load)..execute();
  }

  final String? _seriesId;
  final LibraryRepository _libraryRepository;

  late final Command0 load;

  final List<LibraryModel?> _libraryItems = [];

  List<LibraryModel?> get libraryItems => _libraryItems;

  Future<Result<void>> _load() async {
    await _libraryRepository.scanFolder();
    final result = await _libraryRepository.getLibrary(_seriesId);
    switch (result) {
      case Ok():
        _libraryItems.clear();
        _libraryItems.addAll(result.value);
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
