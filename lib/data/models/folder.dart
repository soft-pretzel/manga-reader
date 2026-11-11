import 'library_item.dart';

class Folder extends LibraryItem {
  List<String?> covers;
  int itemCount;
  bool parsing;

  Folder({
    required super.id,
    this.covers = const [],
    required super.dateAdded,
    required this.itemCount,
    super.parentId,
    this.parsing = true,
    required super.path,
    required super.title,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date_added': dateAdded.toString(),
      'item_count': itemCount,
      'parent_id': parentId,
      'path': path,
      'title': title,
    };
  }

  Folder.fromMap(super.map)
    : covers = List.filled(3, null),
      itemCount = int.parse(map['item_count'].toString()),
      parsing = false,
      super.fromMap();
}
