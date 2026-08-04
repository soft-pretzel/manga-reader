import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/result.dart';

class SharedPreferencesService {
  static const _folderKey = 'folder';

  Future<Result<String?>> getFolder() async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(),
      );
      return Result.ok(prefs.getString(_folderKey));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> setFolder(String folder) async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(),
      );
      await prefs.setString(_folderKey, folder);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
