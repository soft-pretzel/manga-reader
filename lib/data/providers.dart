import 'package:manga_reader/data/services/sqflite_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'repositories/library_repository.dart';
import 'services/archive_service.dart';
import 'services/file_picker_service.dart';
import 'services/path_provider_service.dart';
import 'services/saf_stream_service.dart';
import 'services/saf_util_service.dart';
import 'services/shared_preferences_service.dart';
import 'services/uuid_service.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => ArchiveService()),
    Provider(create: (context) => FilePickerService()),
    Provider(create: (context) => PathProviderService()),
    Provider(create: (context) => SafStreamService()),
    Provider(create: (context) => SafUtilService()),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(create: (context) => SqfliteService()),
    Provider(create: (context) => UuidService()),
    Provider(
      create: (context) => LibraryRepository(
        archiveService: context.read(),
        filePickerService: context.read(),
        pathProviderService: context.read(),
        safStreamService: context.read(),
        safUtilService: context.read(),
        sharedPreferencesService: context.read(),
        sqfliteService: context.read(),
        uuidService: context.read(),
      ),
    ),
  ];
}
