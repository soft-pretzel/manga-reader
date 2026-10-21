import 'dart:typed_data';

import 'library.dart';

enum ReadingStatus { unread, inProgress, finished }

class Book extends Library {
  Uint8List? cover;
  int currentPage;
  DateTime? lastRead;
  int? length;
  ReadingStatus readingStatus;

  Book({
    required super.id,
    this.cover,
    this.currentPage = 1,
    required super.dateAdded,
    this.lastRead,
    this.length,
    required super.name,
    required super.parentId,
    required super.path,
    this.readingStatus = .unread,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'cover': cover,
      'current_page': currentPage,
      'date_added': dateAdded.toString(),
      'last_read': lastRead.toString(),
      'length': length,
      'name': name,
      'parent_id': parentId,
      'path': path,
      'reading_status': readingStatus.index,
    };
  }

  Book.fromMap(super.map)
    : cover = map['cover'] != null ? map['cover'] as Uint8List : null,
      currentPage = int.parse(map['current_page'].toString()),
      lastRead = DateTime.tryParse(map['last_read'].toString()),
      length = int.tryParse(map['length'].toString()),
      readingStatus =
          ReadingStatus.values[int.parse(map['reading_status'].toString())],
      super.fromMap();
}
