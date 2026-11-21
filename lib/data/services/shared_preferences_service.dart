import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/book.dart';
import '../models/settings.dart';

class SharedPreferencesService {
  static const _kDoubleTapZoom = 'double_tap_zoom';
  static const _kDynamicMode = 'dynamic_mode';
  static const _kEreaderMode = 'ereader_mode';
  static const _kLibraryDisplayMode = 'library_display_mode';
  static const _kLibraryFilter = 'library_filter';
  static const _kLibrarySort = 'library_sort';
  static const _kLibrarySpacing = 'library_spacing';
  static const _kOledDarkMode = 'oled_dark_mode';
  static const _kReadingDirection = 'reading_direction';
  static const _kReadingMode = 'reading_mode';
  static const _kThemeColor = 'theme_color';
  static const _kThemeMode = 'theme_mode';
  static const _kZoom = 'zoom';

  Future<bool> getDoubleTapZoom() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getBool(_kDoubleTapZoom) ?? true;
  }

  Future<bool> getDynamicMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getBool(_kDynamicMode) ?? false;
  }

  Future<bool> getEreaderMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getBool(_kEreaderMode) ?? false;
  }

  Future<LibraryDisplayMode> getLibraryDisplayMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_kLibraryDisplayMode);
    return index != null ? .values[index] : .grid;
  }

  Future<List<ReadingStatus>> getLibraryFilter() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    List<ReadingStatus> filter = [];
    final list = prefs.getStringList(_kLibraryFilter);
    if (list != null) {
      filter.addAll(list.map((item) => .values[int.parse(item)]));
    }
    return filter;
  }

  Future<LibrarySort> getLibrarySort() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_kLibrarySort);
    return index != null ? .values[index] : .alphabetical;
  }

  Future<LibrarySpacing> getLibrarySpacing() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_kLibrarySpacing);
    return index != null ? .values[index] : .normal;
  }

  Future<bool> getOledDarkMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getBool(_kOledDarkMode) ?? false;
  }

  Future<ReadingDirection> getReadingDirection() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_kReadingDirection);
    return index != null ? .values[index] : .leftToRight;
  }

  Future<ReadingMode> getReadingMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_kReadingMode);
    return index != null ? .values[index] : .single;
  }

  Future<Color> getThemeColor() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final value = prefs.getInt(_kThemeColor);
    return value != null ? Color(value) : Color(0xff6750a4);
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final index = prefs.getInt(_kThemeMode);
    return index != null ? ThemeMode.values[index] : ThemeMode.system;
  }

  Future<double> getZoom() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    return prefs.getDouble(_kZoom) ?? 2.5;
  }

  Future<void> setDynamicMode(bool dynamicMode) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setBool(_kDynamicMode, dynamicMode);
  }

  Future<void> setLibraryDisplayMode(
    LibraryDisplayMode libraryDisplayMode,
  ) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setInt(_kLibraryDisplayMode, libraryDisplayMode.index);
  }

  Future<void> setLibraryFilter(List<ReadingStatus> libraryFilter) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setStringList(
      _kLibraryFilter,
      libraryFilter.map((item) => item.index.toString()).toList(),
    );
  }

  Future<void> setLibrarySort(LibrarySort librarySort) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setInt(_kLibrarySort, librarySort.index);
  }

  Future<void> setLibrarySpacing(LibrarySpacing librarySpacing) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setInt(_kLibrarySpacing, librarySpacing.index);
  }

  Future<void> setOledDarkMode(bool oledDarkMode) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setBool(_kOledDarkMode, oledDarkMode);
  }

  Future<void> setReadingDirection(ReadingDirection readingDirection) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setInt(_kReadingDirection, readingDirection.index);
  }

  Future<void> setReadingMode(ReadingMode readingMode) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setInt(_kReadingMode, readingMode.index);
  }

  Future<void> setThemeColor(Color themeColor) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setInt(_kThemeColor, themeColor.toARGB32());
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setInt(_kThemeMode, themeMode.index);
  }

  Future<void> setZoom(double zoom) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setDouble(_kZoom, zoom);
  }

  Future<bool> toggleDoubleTapZoom() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final current = prefs.getBool(_kDoubleTapZoom) ?? true;
    await prefs.setBool(_kDoubleTapZoom, !current);
    return !current;
  }

  Future<bool> toggleEreaderMode() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final current = prefs.getBool(_kEreaderMode) ?? false;
    await prefs.setBool(_kEreaderMode, !current);
    return !current;
  }
}
