import 'library.dart';

enum ReadingStatus { unread, inProgress, finished }

class Book extends Library {
  int currentPage;
  DateTime? lastRead;
  int? length;
  final String path;
  ReadingStatus readingStatus;

  Book({
    required super.id,
    this.currentPage = 1,
    required super.dateAdded,
    this.lastRead,
    this.length,
    required super.name,
    required this.path,
    this.readingStatus = .unread,
    super.seriesId,
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
      'path': path,
      'reading_status': readingStatus.index,
      'series_id': seriesId,
      'thumbnail': thumbnail,
    };
  }

  Book.fromMap(super.map)
    : currentPage = int.parse(map['current_page'].toString()),
      lastRead = DateTime.tryParse(map['last_read'].toString()),
      length = int.tryParse(map['length'].toString()),
      path = map['path'].toString(),
      readingStatus =
          ReadingStatus.values[int.parse(map['reading_status'].toString())],
      super.fromMap();
}
