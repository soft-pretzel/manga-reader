import 'dart:io';

import 'package:flutter/foundation.dart';

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
    this._folderId,
    required this._settingsRepository,
  }) {
    getFolderItemCount = Command1(_getFolderItemCount);
    getTitle = Command0(_getTitle);
    loadAnimations = Command0(_loadAnimations)..execute();
    loadLibrary = Command0(_loadLibrary)..execute();
    loadThumbnails = Command0(_loadThumbnails)..execute();
    markAsFinished = Command1(_markAsFinished);
    markAsUnread = Command1(_markAsUnread);
    refresh = Command0(_refresh);
    scanFolder = Command1(_scanFolder);
  }

  final LibraryRepository _libraryRepository;
  final String? _folderId;
  final SettingsRepository _settingsRepository;

  late final Command1<void, Folder> getFolderItemCount;
  late final Command0 getTitle;
  late final Command0 loadAnimations;
  late final Command0 loadLibrary;
  late final Command0 loadThumbnails;
  late final Command1<void, Book> markAsFinished;
  late final Command1<void, Book> markAsUnread;
  late final Command0 refresh;
  late final Command1<void, Folder> scanFolder;

  late bool _animations;
  List<Library?> _library = [];
  String _title = 'Library';

  bool get animations => _animations;
  List<Library?> get library => _library;
  String get title => _title;

  Future<Result<void>> _loadAnimations() async {
    final result = await _settingsRepository.getAnimations();
    switch (result) {
      case Ok():
        _animations = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadLibrary() async {
    final result = await _libraryRepository.getLibrary(_folderId);
    switch (result) {
      case Ok():
        _library = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadThumbnails() async {
    if (_library.isNotEmpty) {
      for (final item in _library) {
        if (item!.thumbnail == null ||
            (item.thumbnail != null &&
                File(item.thumbnail!).existsSync() == false)) {
          final result = await _libraryRepository.getThumbnail(item);
          switch (result) {
            case Ok():
              item.thumbnail = result.value;
              notifyListeners();
            case Error():
              return Result.error(result.error);
          }
        }
      }
    }
    return Result.ok(null);
  }

  Future<Result<void>> _getFolderItemCount(Folder folder) async {
    final result = await _libraryRepository.getFolderBookCount(folder);
    switch (result) {
      case Ok():
        folder.itemCount = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _getTitle() async {
    if (_folderId != null) {
      final result = await _libraryRepository.getFolderName(_folderId);
      switch (result) {
        case Ok():
          _title = result.value;
          notifyListeners();
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    }
    return Result.ok(null);
  }

  Future<Result<void>> _markAsFinished(Book book) async {
    try {
      book.status = .finished;
      notifyListeners();
      _libraryRepository.deleteBookCache(book.id);
      _libraryRepository.updateBook(book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _markAsUnread(Book book) async {
    try {
      book.status = .unread;
      notifyListeners();
      _libraryRepository.deleteBookCache(book.id);
      _libraryRepository.updateBook(book);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _refresh() async {
    try {
      await _loadLibrary();
      await Future.wait([_loadAnimations(), _loadThumbnails()]);
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
