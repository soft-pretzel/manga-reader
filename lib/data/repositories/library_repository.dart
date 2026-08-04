import 'dart:async';
import 'dart:io';

import '../models/book_model.dart';
import '../models/library_model.dart';
import '../models/series_model.dart';
import '../services/database_service.dart';
import '../services/local_storage_service.dart';
import '../services/shared_preferences_service.dart';
import '../../utils/result.dart';

class LibraryRepository {
  LibraryRepository({
    required this._databaseService,
    required this._localStorageService,
    required this._sharedPreferencesService,
  });

  final DatabaseService _databaseService;
  final LocalStorageService _localStorageService;
  final SharedPreferencesService _sharedPreferencesService;

  static List<String> imgTypes = ['jpeg', 'jpg', 'png'];

  Future<Result<String?>> getFolder() async {
    try {
      final result = await _sharedPreferencesService.getFolder();
      switch (result) {
        case Ok():
          return Result.ok(result.value);
        case Error():
          return Result.error(result.error);
      }
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
