import 'library_item.dart';

class Folder extends LibraryItem {
  List<String?> covers;
  int itemCount;
  DateTime? lastModified;
  final String? parentId;
  bool parsing;
  final String path;
  String name;

  Folder({
    required super.id,
    this.covers = const [],
    required super.dateAdded,
    required this.itemCount,
    this.lastModified,
    this.parentId,
    this.parsing = true,
    required this.path,
    required this.name,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date_added': dateAdded.millisecondsSinceEpoch,
      'item_count': itemCount,
      if (lastModified != null)
        'last_modified': lastModified!.millisecondsSinceEpoch,
      'parent_id': parentId,
      'path': path,
      'name': name,
    };
  }

  Folder.fromMap(super.map)
    : covers = List.filled(3, null),
      itemCount = int.parse(map['item_count'].toString()),
      lastModified = map['last_modified'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.parse(map['last_modified'].toString()),
            )
          : null,
      parentId = map['parent_id']?.toString(),
      parsing = false,
      path = map['path'].toString(),
      name = map['title'].toString(),
      super.fromMap();
}
