import 'package:flutter/widgets.dart';

import '../../../../data/repositories/settings_repository.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class StorageSettingsViewModel extends ChangeNotifier {
  StorageSettingsViewModel({required this._settingsRepository}) {
    load = Command0(_load)..execute();
    setFolder = Command0(_setFolder);
  }

  final SettingsRepository _settingsRepository;

  late Command0 load;
  late final Command0 setFolder;

  String? _folder;

  String? get folder => _folder;

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
        _folder = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
