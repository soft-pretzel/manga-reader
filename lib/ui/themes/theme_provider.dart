import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    loadThemeColor();
    loadThemeMode();
  }

  Color _color = Color(0xff6750a4);
  ThemeMode _mode = .system;

  Color get color => _color;
  ThemeMode get mode => _mode;

  static const _themeColorKey = 'theme_color';
  static const _themeModeKey = 'theme_mode';

  Future<void> loadThemeColor() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final value = prefs.getInt(_themeColorKey);
    _color = value != null ? Color(value) : Color(0xff6750a4);
    notifyListeners();
  }

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_themeModeKey);
    _mode = index != null ? ThemeMode.values[index] : ThemeMode.system;
    notifyListeners();
  }
}
