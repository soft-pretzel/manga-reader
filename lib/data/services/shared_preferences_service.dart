import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _foldersKey = 'folders';
  static const String _currentBookKey = 'current_book';

  Future<bool> addFolder(String folder) async {
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
          cacheOptions: SharedPreferencesWithCacheOptions(),
        );
    final folders = prefs.getStringList(_foldersKey) ?? [];
    if (!folders.contains(folder)) {
      folders.add(folder);
      await prefs.setStringList(_foldersKey, folders);
      return true;
    }
    return false;
  }

  Future<bool> deleteFolder(String folder) async {
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
          cacheOptions: SharedPreferencesWithCacheOptions(),
        );
    final folders = prefs.getStringList(_foldersKey) ?? [];
    if (folders.remove(folder)) {
      await prefs.setStringList(_foldersKey, folders);
      return true;
    } else {
      return false;
    }
  }

  Future<List<String>> getFolders() async {
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
          cacheOptions: SharedPreferencesWithCacheOptions(),
        );
    return prefs.getStringList(_foldersKey) ?? [];
  }

  Future<void> setCurrentBook(int id) async {
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
          cacheOptions: SharedPreferencesWithCacheOptions(),
        );
    await prefs.setInt(_currentBookKey, id);
  }

  Future<int?> getCurrentBook() async {
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
          cacheOptions: SharedPreferencesWithCacheOptions(),
        );
    return prefs.getInt(_currentBookKey);
  }
}
