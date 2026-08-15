import 'package:shared_preferences/shared_preferences.dart';

import '../models/reading_direction.dart';
import '../models/reading_mode.dart';

class SharedPreferencesService {
  static const _animationsKey = 'animations';
  static const _folderKey = 'folder';
  static const _readingDirectionKey = 'reading_direction';
  static const _readingModeKey = 'reading_mode';

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

  Future<void> setFolder(String folder) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setString(_folderKey, folder);
  }

  Future<void> setAnimations() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final current = await getAnimations();
    await prefs.setBool(_animationsKey, !current);
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
}
