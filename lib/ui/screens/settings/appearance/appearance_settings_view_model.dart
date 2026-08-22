import 'package:flutter/material.dart';

import '../../../../data/repositories/settings_repository.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class AppearanceSettingsViewModel extends ChangeNotifier {
  AppearanceSettingsViewModel({required this._settingsRepository}) {
    load = Command0(_load)..execute();
    setTheme = Command1(_setTheme);
  }

  final SettingsRepository _settingsRepository;

  late Command0 load;
  late Command1<void, ThemeMode> setTheme;

  late ThemeMode _theme;

  ThemeMode get theme => _theme;

  Future<Result<void>> _load() async {
    try {
      Future.wait([_loadTheme()]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadTheme() async {
    final result = await _settingsRepository.getTheme();
    switch (result) {
      case Ok():
        _theme = result.value;
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _setTheme(ThemeMode theme) async {
    final result = await _settingsRepository.setTheme(theme);
    switch (result) {
      case Ok():
        _theme = theme;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
