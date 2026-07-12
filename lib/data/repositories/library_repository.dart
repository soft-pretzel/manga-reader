import 'dart:async';

import '../services/file_picker_service.dart';
import '../services/shared_preferences_service.dart';
import '../../utils/result.dart';

class LibraryRepository {
  LibraryRepository();

  final FilePickerService _filePickerService = FilePickerService();
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  Future<Result<List<String>>> addFolder() async {
    try {
      final foldersList = await _sharedPreferencesService.getFolders();
      final foldersSet = foldersList.toSet();
      final folder = await _filePickerService.getDirectoryPath();
      if (folder != null) {
        foldersSet.add(folder);
        await _sharedPreferencesService.setFolders(foldersSet.toList());
      }
      return Result.ok(foldersSet.toList());
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<String>>> deleteFolder(String folder) async {
    try {
      final folders = await _sharedPreferencesService.getFolders();
      if (folders.remove(folder)) {
        await _sharedPreferencesService.setFolders(folders);
      }
      return Result.ok(folders);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<String>>> getFolders() async {
    try {
      final folders = await _sharedPreferencesService.getFolders();
      return Result.ok(folders);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
