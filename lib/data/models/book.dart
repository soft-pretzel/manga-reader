import 'package:unseal/unseal.dart';

import 'library.dart';

enum ReadingStatus { unread, inProgress, finished }

class Book extends LibraryItem {
  final String id;
  double? aspectRatio;
  String? author;
  String? cover;
  int currentPage;
  final DateTime dateAdded;
  String? description;
  BookFormat? format;
  List<String> genres;
  String? goodreads;
  String? isbn;
  String? language;
  DateTime? lastModified;
  DateTime? lastRead;
  String? libraryThing;
  String? openLibrary;
  int? pageCount;
  final String? parentId;
  final String path;
  int? publishYear;
  String? publisher;
  ReadingStatus readingStatus;
  String? series;
  double? seriesIndex;
  String? subtitle;
  String title;

  Book({
    required this.id,
    this.aspectRatio,
    this.author,
    this.cover,
    this.currentPage = 1,
    required this.dateAdded,
    this.description,
    this.format,
    this.genres = const [],
    this.goodreads,
    this.isbn,
    this.language,
    this.lastModified,
    this.lastRead,
    this.libraryThing,
    this.openLibrary,
    this.pageCount,
    required this.parentId,
    required this.path,
    this.publishYear,
    this.publisher,
    this.readingStatus = .unread,
    this.series,
    this.seriesIndex,
    this.subtitle,
    required this.title,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (author != null) 'author': author,
      if (cover != null) 'cover': cover,
      'current_page': currentPage,
      'date_added': dateAdded.millisecondsSinceEpoch,
      if (description != null) 'description': description,
      if (format != null) 'format': format!.index,
      'genres': genres.join(","),
      if (goodreads != null) 'goodreads': goodreads,
      if (isbn != null) 'isbn': isbn,
      if (language != null) 'language': language,
      if (lastModified != null)
        'last_modified': lastModified!.millisecondsSinceEpoch,
      if (lastRead != null) 'last_read': lastRead!.millisecondsSinceEpoch,
      if (libraryThing != null) 'library_thing': libraryThing,
      if (openLibrary != null) 'open_library': openLibrary,
      if (pageCount != null) 'page_count': pageCount,
      'parent_id': parentId,
      'path': path,
      if (publishYear != null) 'publish_year': publishYear,
      if (publisher != null) 'publisher': publisher,
      'reading_status': readingStatus.index,
      if (series != null) 'series': series,
      if (seriesIndex != null) 'series_index': seriesIndex,
      if (subtitle != null) 'subtitle': subtitle,
      'title': title,
    };
  }

  Book.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      aspectRatio = double.tryParse(map['aspect_ratio'].toString()),
      author = map['author']?.toString(),
      cover = map['cover']?.toString(),
      currentPage = int.parse(map['current_page'].toString()),
      dateAdded = DateTime.fromMillisecondsSinceEpoch(
        int.parse(map['date_added'].toString()),
      ),
      description = map['description']?.toString(),
      format = map['format'] != null
          ? BookFormat.values[int.parse(map['format'].toString())]
          : null,
      genres = map['genres'].toString().split(","),
      goodreads = map['goodreads']?.toString(),
      isbn = map['isbn']?.toString(),
      language = map['language']?.toString(),
      lastModified = map['last_modified'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.parse(map['last_modified'].toString()),
            )
          : null,
      lastRead = map['last_read'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.parse(map['last_read'].toString()),
            )
          : null,
      libraryThing = map['library_thing']?.toString(),
      openLibrary = map['open_library']?.toString(),
      pageCount = int.tryParse(map['page_count'].toString()),
      parentId = map['parent_id']?.toString(),
      path = map['path'].toString(),
      publishYear = int.tryParse(map['publish_year'].toString()),
      publisher = map['publisher']?.toString(),
      readingStatus =
          ReadingStatus.values[int.parse(map['reading_status'].toString())],
      series = map['series']?.toString(),
      seriesIndex = double.tryParse(map['series_index'].toString()),
      subtitle = map['subtitle']?.toString(),
      title = map['title'].toString();
}
