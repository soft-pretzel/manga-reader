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
    toggleOledDarkMode = Command0(_toggleOledDarkMode);
  }

  final ThemeProvider _themeProvider;
  final SettingsRepository _settingsRepository;

  late Command0 load;
  late Command1<void, Color> setThemeColor;
  late Command1<void, ThemeMode> setThemeMode;
  late Command0 toggleOledDarkMode;

  late bool _oledDarkMode;
  late Color _themeColor;
  late ThemeMode _themeMode;

  bool get oledDarkMode => _oledDarkMode;
  Color get themeColor => _themeColor;
  ThemeMode get themeMode => _themeMode;

  Future<Result<void>> _load() async {
    try {
      Future.wait([_loadOledDarkMode(), _loadThemeColor(), _loadThemeMode()]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadOledDarkMode() async {
    final result = await _settingsRepository.getOledDarkMode();
    switch (result) {
      case Ok():
        _oledDarkMode = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
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

  Future<Result<void>> _toggleOledDarkMode() async {
    try {
      _oledDarkMode = !_oledDarkMode;
      notifyListeners();
      await _settingsRepository.toggleOledDarkMode();
      _themeProvider.loadOledDarkMode();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
