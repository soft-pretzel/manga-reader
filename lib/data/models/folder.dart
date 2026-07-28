class Folder {
  final String id;
  String name;
  String path;
  final String? parentId;

  Folder({
    required this.id,
    required this.name,
    required this.path,
    this.parentId,
  });

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'path': path, 'parent_id': parentId};
  }

  Folder.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      name = map['name'].toString(),
      path = map['path'].toString(),
      parentId = map['parent_id'].toString();

  @override
  String toString() {
    return 'Folder{id: $id, name: $name, path: $path, parent_id: $parentId}';
  }
}
