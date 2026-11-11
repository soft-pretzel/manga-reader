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
      _cacheSize = await _settingsRepository.getCacheInfo();
      _dbSize = await _settingsRepository.getDatabaseInfo();
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
