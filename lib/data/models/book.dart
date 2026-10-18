import 'library.dart';

enum ReadingStatus { unread, inProgress, finished }

class Book extends Library {
  int currentPage;
  DateTime? lastRead;
  int? length;
  ReadingStatus status;

  Book({
    required super.id,
    this.currentPage = 1,
    required super.dateAdded,
    this.lastRead,
    this.length,
    required super.name,
    required super.parentId,
    required super.path,
    this.status = .unread,
    super.thumbnail,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'current_page': currentPage,
      'date_added': dateAdded.toString(),
      'last_read': lastRead.toString(),
      'length': length,
      'name': name,
      'parent_id': parentId,
      'path': path,
      'status': status.index,
      'thumbnail': thumbnail,
    };
  }

  Book.fromMap(super.map)
    : currentPage = int.parse(map['current_page'].toString()),
      lastRead = DateTime.tryParse(map['last_read'].toString()),
      length = int.tryParse(map['length'].toString()),
      status = ReadingStatus.values[int.parse(map['status'].toString())],
      super.fromMap();
}
