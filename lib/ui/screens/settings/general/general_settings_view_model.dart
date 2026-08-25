import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../data/repositories/settings_repository.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class GeneralSettingsViewModel extends ChangeNotifier {
  GeneralSettingsViewModel({required this._settingsRepository}) {
    load = Command0(_load)..execute();
    openLink = Command1(_openLink);
  }

  final SettingsRepository _settingsRepository;

  late Command0 load;
  late Command1<void, Uri> openLink;

  late String _version;

  String get version => _version;

  Future<Result<void>> _load() async {
    try {
      Future.wait([_loadVersion()]);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _loadVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _version = packageInfo.version;
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
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
