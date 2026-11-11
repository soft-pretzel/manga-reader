import 'package:flutter/widgets.dart';

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
      _version = await _settingsRepository.getAppVersion();
      notifyListeners();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _openLink(Uri url) async {
    try {
      await _settingsRepository.openLink(url);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
