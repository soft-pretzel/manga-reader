import 'package:flutter/widgets.dart';

import '../../../../data/repositories/settings_repository.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class StorageSettingsViewModel extends ChangeNotifier {
  StorageSettingsViewModel({required this._settingsRepository}) {
    load = Command0(_load)..execute();
  }

  final SettingsRepository _settingsRepository;

  late Command0 load;

  late String _cacheSize;
  late String _dbSize;

  String get cacheSize => _cacheSize;
  String get dbSize => _dbSize;

  Future<Result<void>> _load() async {
    try {
      await Future.wait([_loadCacheSize(), _loadDatabaseSize()]);
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
}
