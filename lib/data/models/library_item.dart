import 'package:flutter/material.dart';

abstract class LibraryItem {
  final String id;
  String name;
  String path;
  String? thumbnail;
  String? parentId;

  LibraryItem({
    required this.id,
    required this.name,
    required this.path,
    this.thumbnail,
    this.parentId,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'thumbnail': thumbnail,
      'parent_id': parentId,
    };
  }

  LibraryItem.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      name = map['name'].toString(),
      path = map['path'].toString(),
      parentId = map['parent_id'].toString();

  Widget buildCard(BuildContext context);
}
