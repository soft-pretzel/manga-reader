import 'package:shared_preferences/shared_preferences.dart';

import '../models/reading_direction.dart';

class SharedPreferencesService {
  static const _folderKey = 'folder';
  static const _readingDirectionKey = 'reading_direction';

  Future<void> deleteFolder() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.remove(_folderKey);
  }

  Future<String?> getFolder() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getString(_folderKey);
  }

  Future<ReadingDirection?> getReadingDirection() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_readingDirectionKey);
    return index != null ? ReadingDirection.values[index] : null;
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
}
