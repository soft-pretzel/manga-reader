import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';

class SharedPreferencesService {
  static const _animationsKey = 'animations';
  static const _folderKey = 'folder';
  static const _readingDirectionKey = 'reading_direction';
  static const _readingModeKey = 'reading_mode';
  static const _themeKey = 'theme';
  static const _zoomKey = 'zoom';

  Future<void> deleteFolder() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.remove(_folderKey);
  }

  Future<bool> getAnimations() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final value = prefs.getBool(_animationsKey);
    return value ?? true;
  }

  Future<String?> getFolder() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getString(_folderKey);
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

  Future<ThemeMode> getTheme() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_themeKey);
    return index != null ? ThemeMode.values[index] : ThemeMode.system;
  }

  Future<double> getZoom() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final value = prefs.getDouble(_zoomKey);
    return value ?? 2.5;
  }

  Future<void> setFolder(String folder) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setString(_folderKey, folder);
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

  Future<void> setTheme(ThemeMode theme) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setInt(_themeKey, theme.index);
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
    final current = await getAnimations();
    prefs.setBool(_animationsKey, !current);
    return !current;
  }
}
