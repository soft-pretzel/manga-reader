import 'package:flutter/widgets.dart';

import '../../../../data/models/settings.dart';
import '../../../../data/repositories/settings_repository.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class ReaderSettingsViewModel extends ChangeNotifier {
  ReaderSettingsViewModel({required this._settingsRepository}) {
    load = Command0(_load)..execute();
    setReadingDirection = Command1(_setReadingDirection);
    setReadingMode = Command1(_setReadingMode);
    setZoom = Command1(_setZoom);
    toggleAnimations = Command0(_toggleAnimations);
    toggleDoubleTapZoom = Command0(_toggleDoubleTapZoom);
  }

  final SettingsRepository _settingsRepository;

  late Command0 load;
  late Command1<void, ReadingDirection> setReadingDirection;
  late Command1<void, ReadingMode> setReadingMode;
  late Command1<void, double> setZoom;
  late Command0 toggleAnimations;
  late Command0 toggleDoubleTapZoom;

  late bool _animations;
  late bool _doubleTapZoom;
  late ReadingDirection _readingDirection;
  late ReadingMode _readingMode;
  late double _zoom;

  bool get animations => _animations;
  bool get doubleTapZoom => _doubleTapZoom;
  ReadingDirection get readingDirection => _readingDirection;
  ReadingMode get readingMode => _readingMode;
  double get zoom => _zoom;

  Future<Result<void>> _load() async {
    try {
      Future.wait([
        _loadAnimations(),
        _loadDoubleTapZoom(),
        _loadReadingDirection(),
        _loadReadingMode(),
        _loadZoom(),
      ]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

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

  Future<Result<void>> _loadDoubleTapZoom() async {
    final result = await _settingsRepository.getDoubleTapZoom();
    switch (result) {
      case Ok():
        _doubleTapZoom = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadReadingDirection() async {
    final result = await _settingsRepository.getReadingDirection();
    switch (result) {
      case Ok():
        _readingDirection = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadReadingMode() async {
    final result = await _settingsRepository.getReadingMode();
    switch (result) {
      case Ok():
        _readingMode = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _loadZoom() async {
    final result = await _settingsRepository.getZoom();
    switch (result) {
      case Ok():
        _zoom = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _setReadingDirection(
    ReadingDirection readingDirection,
  ) async {
    try {
      _readingDirection = readingDirection;
      notifyListeners();
      _settingsRepository.setReadingDirection(readingDirection);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setReadingMode(ReadingMode readingMode) async {
    try {
      _readingMode = readingMode;
      notifyListeners();
      _settingsRepository.setReadingMode(readingMode);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setZoom(double zoom) async {
    try {
      _zoom = zoom;
      notifyListeners();
      _settingsRepository.setZoom(zoom);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _toggleAnimations() async {
    try {
      _animations = !_animations;
      notifyListeners();
      _settingsRepository.toggleAnimations();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _toggleDoubleTapZoom() async {
    try {
      _doubleTapZoom = !_doubleTapZoom;
      notifyListeners();
      _settingsRepository.toggleDoubleTapZoom();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
