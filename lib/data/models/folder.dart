import 'library.dart';

class Folder extends Library {
  int itemCount;

  Folder({
    required super.id,
    required super.dateAdded,
    required this.itemCount,
    required super.name,
    super.parentId,
    required super.path,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'cover': cover,
      'date_added': dateAdded.toString(),
      'item_count': itemCount,
      'name': name,
      'parent_id': parentId,
      'path': path,
    };
  }

  Folder.fromMap(super.map)
    : itemCount = int.parse(map['item_count'].toString()),
      super.fromMap();
}
