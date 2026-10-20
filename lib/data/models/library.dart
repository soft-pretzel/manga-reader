abstract class Library {
  final String id;
  final DateTime dateAdded;
  String name;
  final String? parentId;
  final String path;

  Library({
    required this.id,
    required this.dateAdded,
    required this.name,
    this.parentId,
    required this.path,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date_added': dateAdded.toString(),
      'name': name,
      'parent_id': parentId,
      'path': path,
    };
  }

  Library.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      dateAdded = DateTime.parse(map['date_added'].toString()),
      name = map['name'].toString(),
      parentId = map['parent_id']?.toString(),
      path = map['path'].toString();
}
