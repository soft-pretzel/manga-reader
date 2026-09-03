import 'package:flutter/material.dart';

import '../../../../data/repositories/settings_repository.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';
import '../../../themes/theme_provider.dart';

class AppearanceSettingsViewModel extends ChangeNotifier {
  AppearanceSettingsViewModel({
    required this._themeProvider,
    required this._settingsRepository,
  }) {
    load = Command0(_load)..execute();
    setThemeColor = Command1(_setThemeColor);
    setThemeMode = Command1(_setThemeMode);
  }

  final ThemeProvider _themeProvider;
  final SettingsRepository _settingsRepository;

  late Command0 load;
  late Command1<void, Color> setThemeColor;
  late Command1<void, ThemeMode> setThemeMode;

  late Color _themeColor;
  late ThemeMode _themeMode;

  Color get themeColor => _themeColor;
  ThemeMode get themeMode => _themeMode;

  Future<Result<void>> _load() async {
    try {
      Future.wait([_loadThemeColor(), _loadThemeMode()]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadThemeColor() async {
    final result = await _settingsRepository.getThemeColor();
    switch (result) {
      case Ok():
        _themeColor = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadThemeMode() async {
    final result = await _settingsRepository.getThemeMode();
    switch (result) {
      case Ok():
        _themeMode = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _setThemeColor(Color color) async {
    final result = await _settingsRepository.setThemeColor(color);
    switch (result) {
      case Ok():
        _themeColor = color;
        notifyListeners();
        _themeProvider.loadThemeColor();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _setThemeMode(ThemeMode theme) async {
    final result = await _settingsRepository.setThemeMode(theme);
    switch (result) {
      case Ok():
        _themeMode = theme;
        notifyListeners();
        _themeProvider.loadThemeMode();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
