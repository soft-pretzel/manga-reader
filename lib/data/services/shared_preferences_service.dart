import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _folderKey = 'folder';

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

  Future<void> setFolder(String folder) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setString(_folderKey, folder);
  }
}
