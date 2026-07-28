// import 'package:flutter/material.dart';

// import '../../../data/repositories/settings_repository.dart';
// import '../../../utils/command.dart';
// import '../../../utils/result.dart';

// class SettingsViewModel extends ChangeNotifier {
//   SettingsViewModel() {
//     load = Command0(_load)..execute();
//     toggle = Command0(_toggle);
//   }

//   final SettingsRepository _settingsRepository = SettingsRepository();

//   bool _isDarkMode = false;
//   bool get isDarkMode => _isDarkMode;

//   late final Command0<void> load;
//   late final Command0<void> toggle;

//   Future<Result<void>> _load() async {
//     final result = await _settingsRepository.isDarkMode();
//     if (result is Ok<bool>) {
//       _isDarkMode = result.value;
//     }
//     notifyListeners();
//     return result;
//   }

//   Future<Result<void>> _toggle() async {
//     _isDarkMode = !_isDarkMode;
//     final result = await _settingsRepository.setDarkMode(_isDarkMode);
//     notifyListeners();
//     return result;
//   }
// }
