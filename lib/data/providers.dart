import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'repositories/library_repository.dart';
import 'services/file_picker_service.dart';
import 'services/shared_preferences_service.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => FilePickerService()),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(
      create: (context) => LibraryRepository(
        filePickerService: context.read(),
        sharedPreferencesService: context.read(),
      ),
    ),
  ];
}
