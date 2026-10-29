import 'library.dart';

class Folder extends Library {
  List<String?> covers;
  int itemCount;
  bool parsing;

  Folder({
    required super.id,
    this.covers = const [],
    required super.dateAdded,
    required this.itemCount,
    required super.name,
    super.parentId,
    required super.path,
    this.parsing = false,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      if (covers.isNotEmpty) 'covers': covers.join(","),
      'date_added': dateAdded.toString(),
      'item_count': itemCount,
      'name': name,
      'parent_id': parentId,
      'path': path,
    };
  }

  Folder.fromMap(super.map)
    : covers = map['covers'] != null ? map['covers'].toString().split(",") : [],
      itemCount = int.parse(map['item_count'].toString()),
      parsing = false,
      super.fromMap();
}
