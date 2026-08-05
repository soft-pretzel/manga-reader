import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'repositories/library_repository.dart';
import 'repositories/settings_repository.dart';
import 'services/database_service.dart';
import 'services/local_storage_service.dart';
import 'services/shared_preferences_service.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => DatabaseService()),
    Provider(create: (context) => LocalStorageService()),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(
      create: (context) => LibraryRepository(
        databaseService: context.read(),
        localStorageService: context.read(),
        sharedPreferencesService: context.read(),
      ),
    ),
    Provider(
      create: (context) => SettingsRepository(
        localStorageService: context.read(),
        sharedPreferencesService: context.read(),
      ),
    ),
  ];
}
