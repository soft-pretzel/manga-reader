import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';

class SharedPreferencesService {
  static const _animationsKey = 'animations';
  static const _doubleTapZoomKey = 'double_tap_zoom';
  static const _dynamicModeKey = 'dynamic_mode';
  static const _localFoldersKey = 'local_folders';
  static const _oledDarkModeKey = 'oled_dark_mode';
  static const _readingDirectionKey = 'reading_direction';
  static const _readingModeKey = 'reading_mode';
  static const _themeColorKey = 'theme_color';
  static const _themeModeKey = 'theme_mode';
  static const _zoomKey = 'zoom';

  Future<void> addLocalFolder(String folder) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final folders = prefs.getStringList(_localFoldersKey) ?? [];
    folders.add(folder);
    await prefs.setStringList(_localFoldersKey, folders);
  }

  Future<bool> getAnimations() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getBool(_animationsKey) ?? true;
  }

  Future<bool> getDoubleTapZoom() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getBool(_doubleTapZoomKey) ?? true;
  }

  Future<bool> getDynamicMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getBool(_dynamicModeKey) ?? false;
  }

  Future<List<String>> getLocalFolders() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getStringList(_localFoldersKey) ?? [];
  }

  Future<bool> getOledDarkMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getBool(_oledDarkModeKey) ?? false;
  }

  Future<ReadingDirection> getReadingDirection() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_readingDirectionKey);
    return index != null
        ? ReadingDirection.values[index]
        : ReadingDirection.leftToRight;
  }

  Future<ReadingMode> getReadingMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_readingModeKey);
    return index != null ? ReadingMode.values[index] : ReadingMode.single;
  }

  Future<Color> getThemeColor() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final value = prefs.getInt(_themeColorKey);
    return value != null ? Color(value) : Color(0xff6750a4);
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_themeModeKey);
    return index != null ? ThemeMode.values[index] : ThemeMode.system;
  }

  Future<double> getZoom() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getDouble(_zoomKey) ?? 2.5;
  }

  Future<void> setReadingDirection(ReadingDirection readingDirection) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setInt(_readingDirectionKey, readingDirection.index);
  }

  Future<void> setReadingMode(ReadingMode readingMode) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setInt(_readingModeKey, readingMode.index);
  }

  Future<void> setThemeColor(Color color) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setInt(_themeColorKey, color.toARGB32());
  }

  Future<void> setThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setInt(_themeModeKey, theme.index);
  }

  Future<void> setZoom(double zoom) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setDouble(_zoomKey, zoom);
  }

  Future<bool> toggleAnimations() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final current = prefs.getBool(_animationsKey) ?? true;
    prefs.setBool(_animationsKey, !current);
    return !current;
  }

  Future<bool> toggleDynamicMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final current = prefs.getBool(_dynamicModeKey) ?? false;
    prefs.setBool(_dynamicModeKey, !current);
    return !current;
  }

  Future<bool> toggleDoubleTapZoom() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final current = prefs.getBool(_doubleTapZoomKey) ?? true;
    prefs.setBool(_doubleTapZoomKey, !current);
    return !current;
  }

  Future<bool> toggleOledDarkMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final current = prefs.getBool(_oledDarkModeKey) ?? false;
    prefs.setBool(_oledDarkModeKey, !current);
    return !current;
  }
}
