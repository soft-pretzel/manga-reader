import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'library_item.dart';
import '../../routing/routes.dart';

enum BookType { book, comic, pdf }

enum ReadingStatus { notStarted, inProgress, finished }

class BookItem extends LibraryItem {
  final BookType bookType;
  final DateTime dateAdded;
  ReadingStatus readingStatus;
  DateTime? lastRead;
  int? currentPage;

  BookItem({
    required super.id,
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
      'id': id,
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
    return Column(
      children: [
        Card(
          child: InkWell(
            child: () {
              if (thumbnail != null) {
                return Image.file(File(thumbnail!));
              } else {
                return SizedBox();
              }
            }(),
            onTap: () {
              context.pushNamed(RouteNames.reader, pathParameters: {});
            },
          ),
        ),
        Text(name),
      ],
    );
  }
}
