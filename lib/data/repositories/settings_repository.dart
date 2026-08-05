import '../services/local_storage_service.dart';
import '../services/shared_preferences_service.dart';
import '../../utils/result.dart';

class SettingsRepository {
  SettingsRepository({
    required this._localStorageService,
    required this._sharedPreferencesService,
  });

  final LocalStorageService _localStorageService;
  final SharedPreferencesService _sharedPreferencesService;

  Future<Result<void>> deleteFolder() async {
    try {
      await _sharedPreferencesService.deleteFolder();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> getFolder() async {
    try {
      final folder = await _sharedPreferencesService.getFolder();
      if (folder != null) {
        return Result.ok(await _localStorageService.getName(folder));
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> setFolder() async {
    try {
      final folder = await _localStorageService.selectFolder();
      if (folder != null) {
        await _sharedPreferencesService.setFolder(folder);
        return Result.ok(await _localStorageService.getName(folder));
      } else {
        return Result.ok(null);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
