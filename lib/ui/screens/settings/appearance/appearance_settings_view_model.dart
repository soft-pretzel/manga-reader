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
    toggleDynamicMode = Command0(_toggleDynamicMode);
    toggleOledDarkMode = Command0(_toggleOledDarkMode);
  }

  final ThemeProvider _themeProvider;
  final SettingsRepository _settingsRepository;

  late Command0 load;
  late Command1<void, Color> setThemeColor;
  late Command1<void, ThemeMode> setThemeMode;
  late Command0 toggleDynamicMode;
  late Command0 toggleOledDarkMode;

  late bool _dynamicMode;
  late bool _oledDarkMode;
  late Color _themeColor;
  late ThemeMode _themeMode;

  bool get dynamicMode => _dynamicMode;
  bool get oledDarkMode => _oledDarkMode;
  Color get themeColor => _themeColor;
  ThemeMode get themeMode => _themeMode;

  Future<Result<void>> _load() async {
    try {
      _dynamicMode = await _settingsRepository.getDynamicMode();
      _oledDarkMode = await _settingsRepository.getOledDarkMode();
      _themeColor = await _settingsRepository.getThemeColor();
      _themeMode = await _settingsRepository.getThemeMode();
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setThemeColor(Color color) async {
    try {
      _themeColor = color;
      notifyListeners();
      await _settingsRepository.setThemeColor(color);
      _themeProvider.loadThemeColor();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setThemeMode(ThemeMode theme) async {
    try {
      _themeMode = theme;
      notifyListeners();
      await _settingsRepository.setThemeMode(theme);
      _themeProvider.loadThemeMode();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _toggleDynamicMode() async {
    try {
      _dynamicMode = !_dynamicMode;
      notifyListeners();
      await _settingsRepository.setDynamicMode(_dynamicMode);
      _themeProvider.loadDynamicMode();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _toggleOledDarkMode() async {
    try {
      _oledDarkMode = !_oledDarkMode;
      notifyListeners();
      await _settingsRepository.setOledDarkMode(_oledDarkMode);
      _themeProvider.loadOledDarkMode();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
