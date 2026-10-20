import 'package:flutter/material.dart';

import '../../../../data/repositories/library_repository.dart';
import '../../../../data/repositories/settings_repository.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class FolderViewModel extends ChangeNotifier {
  FolderViewModel({
    required this._folderId,
    required this._libraryRepository,
    required this._settingsRepository,
  }) {
    load = Command0(_load)..execute();
  }

  final String _folderId;
  final LibraryRepository _libraryRepository;
  final SettingsRepository _settingsRepository;

  late Command0 load;

  late String _title;

  String get title => _title;

  Future<Result<void>> _load() async {
    try {
      await Future.wait([_loadTitle()]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadTitle() async {
    final result = await _libraryRepository.getName(_folderId);
    switch (result) {
      case Ok():
        _title = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
