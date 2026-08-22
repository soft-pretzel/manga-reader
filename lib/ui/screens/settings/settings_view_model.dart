import 'package:flutter/material.dart';

import '../../../data/repositories/settings_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({this._setting, required this._settingsRepository}) {
    deleteFolder = Command0(_deleteFolder);
    load = Command0(_load)..execute();
    loadTitle = Command0(_loadTitle);
    setFolder = Command0(_setFolder);
  }

  final String? _setting;
  final SettingsRepository _settingsRepository;

  late final Command0 deleteFolder;
  late final Command0 load;
  late final Command0 loadTitle;
  late final Command0 setFolder;

  String? _folder;
  String _title = 'Settings';

  String? get folder => _folder;
  String get title => _title;
  String? get setting => _setting;

  Future<Result<void>> _deleteFolder() async {
    final result = await _settingsRepository.deleteFolder();
    switch (result) {
      case Ok():
        _load();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _load() async {
    _loadTitle();
    final result = await _settingsRepository.getFolder();
    switch (result) {
      case Ok():
        _folder = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadTitle() async {
    try {
      switch (_setting) {
        case 'general':
          _title = 'General';
        case 'appearance':
          _title = 'Appearance';
        case 'local-storage':
          _title = 'Local Storage';
        case 'reader':
          _title = 'Reader';
      }
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setFolder() async {
    final result = await _settingsRepository.setFolder();
    switch (result) {
      case Ok():
        _load();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
