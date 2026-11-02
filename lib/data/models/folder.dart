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
    super.parentId,
    required super.path,
    this.parsing = false,
    required super.title,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      if (covers.isNotEmpty) 'covers': covers.join(","),
      'date_added': dateAdded.toString(),
      'item_count': itemCount,
      'parent_id': parentId,
      'path': path,
      'title': title,
    };
  }

  Folder.fromMap(super.map)
    : covers = map['covers'] != null ? map['covers'].toString().split(",") : [],
      itemCount = int.parse(map['item_count'].toString()),
      parsing = false,
      super.fromMap();
}
