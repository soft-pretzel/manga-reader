import 'package:flutter/material.dart';

import '../models/settings.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import '../services/local_storage_service.dart';
import '../services/shared_preferences_service.dart';
import '../../utils/result.dart';
import '../services/utils_service.dart';

class SettingsRepository {
  SettingsRepository({
    required this._apiService,
    required this._databaseService,
    required this._localStorageService,
    required this._sharedPreferencesService,
    required this._utilsService,
  });

  final ApiService _apiService;
  final DatabaseService _databaseService;
  final LocalStorageService _localStorageService;
  final SharedPreferencesService _sharedPreferencesService;
  final UtilsService _utilsService;

  Future<Result<void>> brightnessDown() async {
    try {
      await _utilsService.brightnessDown();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> brightnessReset() async {
    try {
      await _utilsService.brightnessReset();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> brightnessUp() async {
    try {
      await _utilsService.brightnessUp();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deleteFolder() async {
    try {
      await _sharedPreferencesService.deleteFolder();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<bool>> getAnimations() async {
    try {
      final animations = await _sharedPreferencesService.getAnimations();
      return Result.ok(animations);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String>> getAppVersion() async {
    try {
      final version = await _utilsService.getAppVersion();
      return Result.ok(version);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<bool>> getDoubleTapZoom() async {
    try {
      final doubleTapZoom = await _sharedPreferencesService.getDoubleTapZoom();
      return Result.ok(doubleTapZoom);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String>> getCacheInfo() async {
    try {
      final info = await _localStorageService.getCacheInfo();
      final size = await _utilsService.formatFileSize(info.size);
      return Result.ok(size);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String>> getDatabaseInfo() async {
    try {
      final info = await _databaseService.getDatabaseInfo();
      final size = await _utilsService.formatFileSize(info.size);
      return Result.ok(size);
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

  Future<Result<ReadingDirection>> getReadingDirection() async {
    try {
      final readingDirection = await _sharedPreferencesService
          .getReadingDirection();
      return Result.ok(readingDirection);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<ReadingMode>> getReadingMode() async {
    try {
      final readingMode = await _sharedPreferencesService.getReadingMode();
      return Result.ok(readingMode);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Color>> getThemeColor() async {
    try {
      final themeColor = await _sharedPreferencesService.getThemeColor();
      return Result.ok(themeColor);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<ThemeMode>> getThemeMode() async {
    try {
      final themeMode = await _sharedPreferencesService.getThemeMode();
      return Result.ok(themeMode);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<double>> getZoom() async {
    try {
      final zoom = await _sharedPreferencesService.getZoom();
      return Result.ok(zoom);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> openLink(Uri url) async {
    try {
      await _apiService.openLink(url);
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

  Future<Result<void>> setReadingDirection(
    ReadingDirection readingDirection,
  ) async {
    try {
      await _sharedPreferencesService.setReadingDirection(readingDirection);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> setReadingMode(ReadingMode readingMode) async {
    try {
      await _sharedPreferencesService.setReadingMode(readingMode);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> setThemeColor(Color color) async {
    try {
      await _sharedPreferencesService.setThemeColor(color);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> setThemeMode(ThemeMode theme) async {
    try {
      await _sharedPreferencesService.setThemeMode(theme);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> setZoom(double zoom) async {
    try {
      await _sharedPreferencesService.setZoom(zoom);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<bool>> toggleAnimations() async {
    try {
      final result = await _sharedPreferencesService.toggleAnimations();
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<bool>> toggleDoubleTapZoom() async {
    try {
      final result = await _sharedPreferencesService.toggleDoubleTapZoom();
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
