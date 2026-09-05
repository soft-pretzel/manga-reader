import 'package:flutter/widgets.dart';

import '../../../../data/repositories/settings_repository.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class GeneralSettingsViewModel extends ChangeNotifier {
  GeneralSettingsViewModel({required this._settingsRepository}) {
    loadVersion = Command0(_loadVersion)..execute();
    openLink = Command1(_openLink);
    refresh = Command0(_refresh);
  }

  final SettingsRepository _settingsRepository;

  late Command0 loadVersion;
  late Command1<void, Uri> openLink;
  late Command0 refresh;

  late String _version;

  String get version => _version;

  Future<Result<void>> _refresh() async {
    try {
      await Future.wait([_loadVersion()]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadVersion() async {
    final result = await _settingsRepository.getAppVersion();
    switch (result) {
      case Ok():
        _version = result.value;
        notifyListeners();
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _openLink(Uri url) async {
    final result = await _settingsRepository.openLink(url);
    switch (result) {
      case Ok():
        return Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }
}
