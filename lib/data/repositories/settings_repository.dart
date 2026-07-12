// import 'dart:async';

// import '../services/shared_preferences.dart';
// import '../../utils/result.dart';

// class SettingsRepository {
//   SettingsRepository();

//   final _darkModeController = StreamController<bool>.broadcast();

//   final SharedPreferencesService _sharedPreferencesService =
//       SharedPreferencesService();

//   Future<Result<void>> setLocalFolders(List<String> value) async {
//     try {
//       await _sharedPreferencesService.setLocalFolders(value);
//       return Result.ok(null);
//     } on Exception catch (e) {
//       return Result.error(e);
//     }
//   }

//   Future<Result<List<String>>> getLocalFolders() async {
//     try {
//       final value = await _sharedPreferencesService.getLocalFolders();
//       return Result.ok(value);
//     } on Exception catch (e) {
//       return Result.error(e);
//     }
//   }
// }
