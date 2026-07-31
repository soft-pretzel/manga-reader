import 'library_item.dart';

class FolderItem extends LibraryItem {
  FolderItem({
    required super.id,
    required super.name,
    required super.path,
    super.thumbnail,
    super.parentId,
  });

  FolderItem.fromMap(super.map) : super.fromMap();
}
