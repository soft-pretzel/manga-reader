import 'library_model.dart';

enum ReadingStatus { notStarted, inProgress, finished }

class BookModel extends LibraryModel {
  int? currentPage;
  final String folderId;
  DateTime? lastRead;
  final String path;
  ReadingStatus readingStatus = ReadingStatus.notStarted;
  final String? seriesId;
  String thumbnail;

  BookModel({
    required super.id,
    this.currentPage,
    required super.dateAdded,
    required this.folderId,
    this.lastRead,
    required super.name,
    required this.path,
    required this.readingStatus,
    this.seriesId,
    required this.thumbnail,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'current_page': currentPage,
      'date_added': dateAdded.toString(),
      'folder_id': folderId,
      'last_read': lastRead.toString(),
      'name': name,
      'path': path,
      'reading_status': readingStatus.index,
      'series_id': seriesId,
      'thumbnail': thumbnail,
    };
  }

  BookModel.fromMap(super.map)
    : currentPage = int.tryParse(map['current_page'].toString()),
      folderId = map['folder_id'].toString(),
      lastRead = DateTime.tryParse(map['last_read'].toString()),
      path = map['path'].toString(),
      readingStatus =
          ReadingStatus.values[int.parse(map['reading_status'].toString())],
      seriesId = map['series_id'].toString(),
      thumbnail = map['thumbnail'].toString(),
      super.fromMap();
}
