import 'package:flutter/widgets.dart';

import '../../../../data/repositories/settings_repository.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class StorageSettingsViewModel extends ChangeNotifier {
  StorageSettingsViewModel({required this._settingsRepository}) {
    loadCacheSize = Command0(_loadCacheSize)..execute();
    loadDatabaseSize = Command0(_loadDatabaseSize)..execute();
    loadFolder = Command0(_loadFolder)..execute();
    refresh = Command0(_refresh);
    setFolder = Command0(_setFolder);
  }

  final SettingsRepository _settingsRepository;

  late Command0 loadCacheSize;
  late Command0 loadDatabaseSize;
  late Command0 loadFolder;
  late Command0 refresh;
  late final Command0 setFolder;

  late String _cacheSize;
  late String _dbSize;
  String? _folder;

  String get cacheSize => _cacheSize;
  String get dbSize => _dbSize;
  String? get folder => _folder;

  Future<Result<void>> _refresh() async {
    try {
      await Future.wait([_loadCacheSize(), _loadDatabaseSize(), _loadFolder()]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadCacheSize() async {
    final result = await _settingsRepository.getCacheInfo();
    switch (result) {
      case Ok():
        _cacheSize = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadDatabaseSize() async {
    final result = await _settingsRepository.getDatabaseInfo();
    switch (result) {
      case Ok():
        _dbSize = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadFolder() async {
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
        _folder = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
