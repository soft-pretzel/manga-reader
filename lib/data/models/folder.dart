import 'library.dart';

class Folder extends Library {
  Folder({
    required super.id,
    required super.dateAdded,
    required super.name,
    super.parentId,
    required super.path,
  });

  Folder.fromMap(super.map) : super.fromMap();
}
