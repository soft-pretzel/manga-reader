import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    loadThemeColor();
    loadThemeMode();
  }

  Color _themeColor = Color(0xff6750a4);
  ThemeMode _themeMode = .system;

  Color get themeColor => _themeColor;
  ThemeMode get themeMode => _themeMode;

  static const _themeColorKey = 'theme_color';
  static const _themeModeKey = 'theme_mode';

  Future<void> loadThemeColor() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final value = prefs.getInt(_themeColorKey);
    _themeColor = value != null ? Color(value) : Color(0xff6750a4);
    notifyListeners();
  }

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_themeModeKey);
    _themeMode = index != null ? ThemeMode.values[index] : ThemeMode.system;
    notifyListeners();
  }
}
