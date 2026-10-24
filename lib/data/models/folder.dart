import 'dart:convert';

import 'library.dart';

class Folder extends Library {
  List<String?> covers;
  int itemCount;

  Folder({
    required super.id,
    this.covers = const [],
    required super.dateAdded,
    required this.itemCount,
    required super.name,
    super.parentId,
    required super.path,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'covers': covers.join(","),
      'date_added': dateAdded.toString(),
      'item_count': itemCount,
      'name': name,
      'parent_id': parentId,
      'path': path,
    };
  }

  Folder.fromMap(super.map)
    : covers = map['covers'].toString().split(","),
      itemCount = int.parse(map['item_count'].toString()),
      super.fromMap();
}
