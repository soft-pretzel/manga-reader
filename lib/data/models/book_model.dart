import 'library_model.dart';

enum ReadingStatus { notStarted, inProgress, finished }

class BookModel extends LibraryModel {
  int? currentPage;
  DateTime? lastRead;
  final String path;
  ReadingStatus readingStatus = ReadingStatus.notStarted;
  final String? seriesId;

  BookModel({
    required super.id,
    this.currentPage,
    required super.dateAdded,
    this.lastRead,
    required super.name,
    required this.path,
    required this.readingStatus,
    this.seriesId,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'current_page': currentPage,
      'date_added': dateAdded.toString(),
      'last_read': lastRead.toString(),
      'name': name,
      'path': path,
      'reading_status': readingStatus.index,
      'series_id': seriesId,
    };
  }

  BookModel.fromMap(super.map)
    : currentPage = int.tryParse(map['current_page'].toString()),
      lastRead = DateTime.tryParse(map['last_read'].toString()),
      path = map['path'].toString(),
      readingStatus =
          ReadingStatus.values[int.parse(map['reading_status'].toString())],
      seriesId = map['series_id'].toString(),
      super.fromMap();
}
