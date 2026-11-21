import 'package:material_ui/material_ui.dart';

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

  Future<String> getAppVersion() async {
    return await _utilsService.getAppVersion();
  }

  Future<String> getCacheInfo() async {
    final info = await _localStorageService.getCacheInfo();
    return await _utilsService.formatFileSize(info.size);
  }

  Future<String> getDatabaseInfo() async {
    final info = await _databaseService.getDatabaseInfo();
    return await _utilsService.formatFileSize(info.size);
  }

  Future<bool> getDoubleTapZoom() async {
    return await _sharedPreferencesService.getDoubleTapZoom();
  }

  Future<bool> getDynamicMode() async {
    return await _sharedPreferencesService.getDynamicMode();
  }

  Future<bool> getEreaderMode() async {
    return await _sharedPreferencesService.getEreaderMode();
  }

  Future<LibraryDisplayMode> getLibraryDisplayMode() async {
    return await _sharedPreferencesService.getLibraryDisplayMode();
  }

  Future<List<ReadingStatus>> getLibraryFilter() async {
    return await _sharedPreferencesService.getLibraryFilter();
  }

  Future<LibrarySort> getLibrarySort() async {
    return await _sharedPreferencesService.getLibrarySort();
  }

  Future<LibrarySpacing> getLibrarySpacing() async {
    return await _sharedPreferencesService.getLibrarySpacing();
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

  Future<void> setLibraryDisplayMode(
    LibraryDisplayMode libraryDisplayMode,
  ) async {
    await _sharedPreferencesService.setLibraryDisplayMode(libraryDisplayMode);
  }

  Future<void> setLibraryFilter(List<ReadingStatus> libraryFilter) async {
    await _sharedPreferencesService.setLibraryFilter(libraryFilter);
  }

  Future<void> setLibrarySort(LibrarySort librarySort) async {
    await _sharedPreferencesService.setLibrarySort(librarySort);
  }

  Future<void> setLibrarySpacing(LibrarySpacing librarySpacing) async {
    await _sharedPreferencesService.setLibrarySpacing(librarySpacing);
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

  Future<void> setThemeColor(Color themeColor) async {
    await _sharedPreferencesService.setThemeColor(themeColor);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _sharedPreferencesService.setThemeMode(themeMode);
  }

  Future<void> setZoom(double zoom) async {
    await _sharedPreferencesService.setZoom(zoom);
  }

  Future<void> toggleDoubleTapZoom() async {
    await _sharedPreferencesService.toggleDoubleTapZoom();
  }

  Future<void> toggleEreaderMode() async {
    await _sharedPreferencesService.toggleEreaderMode();
  }
}
