import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/settings.dart';
import '../services/database_service.dart';
import '../services/local_storage_service.dart';
import '../services/shared_preferences_service.dart';
import '../services/utils_service.dart';

class SettingsRepository {
  SettingsRepository({
    required this._databaseService,
    required this._localStorageService,
    required this._sharedPreferencesService,
    required this._utilsService,
  });

  final DatabaseService _databaseService;
  final LocalStorageService _localStorageService;
  final SharedPreferencesService _sharedPreferencesService;
  final UtilsService _utilsService;

  Future<void> brightnessDown() async {
    await _utilsService.brightnessDown();
  }

  Future<void> brightnessReset() async {
    await _utilsService.brightnessReset();
  }

  Future<void> brightnessUp() async {
    await _utilsService.brightnessUp();
  }

  Future<bool> getAnimations() async {
    return await _sharedPreferencesService.getAnimations();
  }

  Future<String> getAppVersion() async {
    return await _utilsService.getAppVersion();
  }

  Future<bool> getDoubleTapZoom() async {
    return await _sharedPreferencesService.getDoubleTapZoom();
  }

  Future<String> getCacheInfo() async {
    final info = await _localStorageService.getCacheInfo();
    return await _utilsService.formatFileSize(info.size);
  }

  Future<String> getDatabaseInfo() async {
    final info = await _databaseService.getDatabaseInfo();
    return await _utilsService.formatFileSize(info.size);
  }

  Future<bool> getDynamicMode() async {
    return await _sharedPreferencesService.getDynamicMode();
  }

  Future<List<ReadingStatus>> getFilter() async {
    return await _sharedPreferencesService.getFilter();
  }

  Future<LibraryDisplayMode> getLibraryDisplayMode() async {
    return await _sharedPreferencesService.getLibraryDisplayMode();
  }

  Future<LibraryDisplaySpacing> getLibraryDisplaySpacing() async {
    return await _sharedPreferencesService.getLibraryDisplaySpacing();
  }

  Future<LibrarySort> getLibrarySort() async {
    return await _sharedPreferencesService.getLibrarySort();
  }

  Future<bool> getOledDarkMode() async {
    return await _sharedPreferencesService.getOledDarkMode();
  }

  Future<ReadingDirection> getReadingDirection() async {
    return await _sharedPreferencesService.getReadingDirection();
  }

  Future<ReadingMode> getReadingMode() async {
    return await _sharedPreferencesService.getReadingMode();
  }

  Future<Color> getThemeColor() async {
    return await _sharedPreferencesService.getThemeColor();
  }

  Future<ThemeMode> getThemeMode() async {
    return await _sharedPreferencesService.getThemeMode();
  }

  Future<double> getZoom() async {
    return await _sharedPreferencesService.getZoom();
  }

  Future<void> openLink(Uri url) async {
    await _utilsService.openLink(url);
  }

  Future<void> setDynamicMode(bool dynamicMode) async {
    await _sharedPreferencesService.setDynamicMode(dynamicMode);
  }

  Future<void> setFilter(List<ReadingStatus> filter) async {
    await _sharedPreferencesService.setFilter(filter);
  }

  Future<void> setLibraryDisplayMode(
    LibraryDisplayMode libraryDisplayMode,
  ) async {
    await _sharedPreferencesService.setLibraryDisplayMode(libraryDisplayMode);
  }

  Future<void> setLibraryDisplaySpacing(
    LibraryDisplaySpacing libraryDisplaySpacing,
  ) async {
    await _sharedPreferencesService.setLibraryDisplaySpacing(
      libraryDisplaySpacing,
    );
  }

  Future<void> setLibrarySort(LibrarySort librarySort) async {
    await _sharedPreferencesService.setLibrarySort(librarySort);
  }

  Future<void> setOledDarkMode(bool oledDarkMode) async {
    await _sharedPreferencesService.setOledDarkMode(oledDarkMode);
  }

  Future<void> setReadingDirection(ReadingDirection readingDirection) async {
    await _sharedPreferencesService.setReadingDirection(readingDirection);
  }

  Future<void> setReadingMode(ReadingMode readingMode) async {
    await _sharedPreferencesService.setReadingMode(readingMode);
  }

  Future<void> setThemeColor(Color color) async {
    await _sharedPreferencesService.setThemeColor(color);
  }

  Future<void> setThemeMode(ThemeMode theme) async {
    await _sharedPreferencesService.setThemeMode(theme);
  }

  Future<void> setZoom(double zoom) async {
    await _sharedPreferencesService.setZoom(zoom);
  }

  Future<bool> toggleAnimations() async {
    return await _sharedPreferencesService.toggleAnimations();
  }

  Future<bool> toggleDoubleTapZoom() async {
    return await _sharedPreferencesService.toggleDoubleTapZoom();
  }
}
