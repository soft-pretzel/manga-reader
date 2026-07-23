import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _foldersKey = 'folders';
  static const String _currentBookKey = 'current_book';

  Future<void> setFolders(List<String> folders) async {
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
          cacheOptions: SharedPreferencesWithCacheOptions(),
        );
    await prefs.setStringList(_foldersKey, folders);
  }

  Future<List<String>> getFolders() async {
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
          cacheOptions: SharedPreferencesWithCacheOptions(),
        );
    return prefs.getStringList(_foldersKey) ?? [];
  }

  Future<void> setCurrentBook(String id) async {
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
          cacheOptions: SharedPreferencesWithCacheOptions(),
        );
    await prefs.setString(_currentBookKey, id);
  }

  Future<String> getCurrentBook() async {
    final SharedPreferencesWithCache prefs =
        await SharedPreferencesWithCache.create(
          cacheOptions: SharedPreferencesWithCacheOptions(),
        );
    return prefs.getString(_currentBookKey) ?? '';
  }
}
