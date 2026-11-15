abstract class LibraryItem {
  final String id;
  final DateTime dateAdded;
  DateTime? lastModified;
  final String? parentId;
  final String path;
  String title;

  LibraryItem({
    required this.id,
    required this.dateAdded,
    this.lastModified,
    this.parentId,
    required this.path,
    required this.title,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date_added': dateAdded.millisecondsSinceEpoch,
      if (lastModified != null)
        'last_modified': lastModified!.millisecondsSinceEpoch,
      'parent_id': parentId,
      'path': path,
      'title': title,
    };
  }

  LibraryItem.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      dateAdded = DateTime.fromMillisecondsSinceEpoch(
        int.parse(map['date_added'].toString()),
      ),
      lastModified = map['last_modified'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.parse(map['last_modified'].toString()),
            )
          : null,
      parentId = map['parent_id']?.toString(),
      path = map['path'].toString(),
      title = map['title'].toString();
}
