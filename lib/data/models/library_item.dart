abstract class LibraryItem {
  final String id;
  final DateTime dateAdded;
  final String? parentId;
  final String path;
  String title;

  LibraryItem({
    required this.id,
    required this.dateAdded,
    this.parentId,
    required this.path,
    required this.title,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date_added': dateAdded.toString(),
      'parent_id': parentId,
      'path': path,
      'title': title,
    };
  }

  LibraryItem.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      dateAdded = DateTime.parse(map['date_added'].toString()),
      parentId = map['parent_id']?.toString(),
      path = map['path'].toString(),
      title = map['title'].toString();
}
