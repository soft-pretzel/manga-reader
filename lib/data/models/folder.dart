import 'library_old.dart';

class Folder extends LibraryItem {
  final String id;
  List<String?> covers;
  int itemCount;
  DateTime? lastModified;
  final DateTime dateAdded;
  final String? parentId;
  bool parsing;
  final String path;
  String name;

  Folder({
    required this.id,
    this.covers = const [],
    required this.dateAdded,
    required this.itemCount,
    this.lastModified,
    this.parentId,
    this.parsing = true,
    required this.path,
    required this.name,
  });

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

  Folder.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      covers = List.filled(3, null),
      dateAdded = DateTime.fromMillisecondsSinceEpoch(
        int.parse(map['date_added'].toString()),
      ),
      itemCount = int.parse(map['item_count'].toString()),
      lastModified = map['last_modified'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.parse(map['last_modified'].toString()),
            )
          : null,
      parentId = map['parent_id']?.toString(),
      parsing = false,
      path = map['path'].toString(),
      name = map['title'].toString();
}
