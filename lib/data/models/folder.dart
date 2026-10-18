import 'library.dart';

class Folder extends Library {
  int? itemCount;

  Folder({
    required super.id,
    this.itemCount,
    required super.dateAdded,
    required super.name,
    super.parentId,
    required super.path,
    super.thumbnail,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'item_count': itemCount,
      'date_added': dateAdded.toString(),
      'name': name,
      'parent_id': parentId,
      'path': path,
      'thumbnail': thumbnail,
    };
  }

  Folder.fromMap(super.map)
    : itemCount = int.tryParse(map['item_count'].toString()),
      super.fromMap();
}
