import 'package:flutter/material.dart';

import '../../../data/repositories/settings_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required this._settingsRepository}) {
    deleteFolder = Command0(_deleteFolder);
    load = Command0(_load)..execute();
    setFolder = Command0(_setFolder);
  }

  final SettingsRepository _settingsRepository;
  late final Command0 deleteFolder;
  late final Command0 load;
  late final Command0 setFolder;

  String? _folder;
  String? get folder => _folder;

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
