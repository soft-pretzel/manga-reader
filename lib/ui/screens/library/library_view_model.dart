import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:unseal/unseal.dart' as unseal;

import '../../../data/models/book.dart';
import '../../../data/models/library.dart';
import '../../../data/models/folder.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({
    required this._libraryRepository,
    required this._settingsRepository,
  }) {
    addLocalFolder = Command0(_addLocalFolder);
    load = Command0(_load)..execute();
    refresh = Command0(_refresh);
  }

  final LibraryRepository _libraryRepository;
  final SettingsRepository _settingsRepository;

  late final Command0 addLocalFolder;
  late final Command0 load;
  late final Command0 refresh;

  late bool _animations;
  List<Folder> _library = [];

  bool get animations => _animations;
  List<Folder> get library => _library;

  Future<Result<void>> _addLocalFolder() async {
    final result = await _libraryRepository.addLocalFolder();
    switch (result) {
      case Ok():
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _load() async {
    try {
      await Future.wait([_loadLibrary()]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadLibrary() async {
    final result = await _libraryRepository.getLibrary();
    switch (result) {
      case Ok():
        _library = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _refresh() async {
    try {
      await Future.wait([_loadLibrary()]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _scanFolder(Folder folder) async {
    final result = await _libraryRepository.scanFolder(folder);
    switch (result) {
      case Ok():
        _refresh();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
