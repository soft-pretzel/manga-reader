abstract class Library {
  final String id;
  final DateTime dateAdded;
  String name;
  final String? parentId;
  final String path;
  String? thumbnail;

  Library({
    required this.id,
    required this.dateAdded,
    required this.name,
    this.parentId,
    required this.path,
    this.thumbnail,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date_added': dateAdded.toString(),
      'name': name,
      'parent_id': parentId,
      'path': path,
      'thumbnail': thumbnail,
    };
  }

  Library.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      dateAdded = DateTime.parse(map['date_added'].toString()),
      name = map['name'].toString(),
      parentId = map['parent_id']?.toString(),
      path = map['path'].toString(),
      thumbnail = map['thumbnail']?.toString();
}
