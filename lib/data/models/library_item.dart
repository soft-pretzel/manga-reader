import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_reader/routing/routes.dart';

enum ItemType { folder, book }

enum BookType { book, comic, pdf }

enum ReadingStatus { notStarted, inProgress, finished }

abstract class LibraryItem {
  final int? id;
  String name;
  String path;
  String? thumbnail;
  final int? parentId;

  LibraryItem({
    this.id,
    required this.name,
    required this.path,
    this.thumbnail,
    this.parentId,
  });

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'path': path,
      'thumbnail': thumbnail,
      'parent_id': parentId,
    };
  }

  LibraryItem.fromMap(Map<String, Object?> map)
    : id = int.parse(map['id'].toString()),
      name = map['name'].toString(),
      path = map['path'].toString(),
      parentId = int.tryParse(map['parent_id'].toString());

  Widget buildCard(BuildContext context);
}

class FolderItem extends LibraryItem {
  final itemType = ItemType.folder;

  FolderItem({
    required super.name,
    required super.path,
    super.thumbnail,
    super.parentId,
  });

  FolderItem.fromMap(super.map) : super.fromMap();

  @override
  Widget buildCard(BuildContext context) {
    return Card(
      child: InkWell(
        child: Center(child: Text(name)),
        onTap: () {
          context.pushNamed(
            RouteNames.folderContents,
            pathParameters: {'folderId': id.toString()},
          );
        },
      ),
    );
  }
}

class BookItem extends LibraryItem {
  final BookType bookType;
  final DateTime dateAdded;
  ReadingStatus readingStatus;
  DateTime? lastRead;
  int? currentPage;

  BookItem({
    required super.name,
    required super.path,
    super.thumbnail,
    super.parentId,
    required this.bookType,
    required this.dateAdded,
    required this.readingStatus,
    this.lastRead,
    this.currentPage,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'name': name,
      'path': path,
      'thumbnail': thumbnail,
      'parent_id': parentId,
      'book_type': bookType.toString(),
      'date_added': dateAdded.toString(),
      'reading_status': readingStatus.toString(),
      'last_read': lastRead.toString(),
      'current_page': currentPage,
    };
  }

  BookItem.fromMap(super.map)
    : bookType = BookType.values.byName(
        map['book_type'].toString().split('.').last,
      ),
      dateAdded = DateTime.parse(map['date_added'].toString()),
      readingStatus = ReadingStatus.values.byName(
        map['reading_status'].toString().split('.').last,
      ),
      lastRead = DateTime.tryParse(map['last_read'].toString()),
      currentPage = int.tryParse(map['current_page'].toString()),
      super.fromMap();

  @override
  Widget buildCard(BuildContext context) {
    return Card(
      child: InkWell(
        child: Center(child: Text(name)),
        onTap: () {
          context.pushNamed(RouteNames.reader, pathParameters: {});
        },
      ),
    );
  }
}
