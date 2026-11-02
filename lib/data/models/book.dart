import 'package:unseal/unseal.dart';

import 'library.dart';

enum ReadingStatus { unread, inProgress, finished }

class Book extends Library {
  String? author;
  String? cover;
  int currentPage;
  String? description;
  BookFormat format;
  String? goodreads;
  String? isbn;
  String? language;
  DateTime? lastRead;
  String? libraryThing;
  String? openLibrary;
  int pageCount;
  DateTime? publishDate;
  String? publisher;
  ReadingStatus readingStatus;
  String? series;
  double? seriesIndex;
  List<String> subjects;
  String? subtitle;

  Book({
    required super.id,
    this.author,
    this.cover,
    this.currentPage = 1,
    required super.dateAdded,
    this.description,
    required this.format,
    this.goodreads,
    this.isbn,
    this.language,
    this.lastRead,
    this.libraryThing,
    this.openLibrary,
    required this.pageCount,
    required super.parentId,
    required super.path,
    this.publishDate,
    this.publisher,
    this.readingStatus = .unread,
    this.series,
    this.seriesIndex,
    this.subjects = const [],
    this.subtitle,
    required super.title,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      if (author != null) 'author': author,
      if (cover != null) 'cover': cover,
      'current_page': currentPage,
      'date_added': dateAdded.toString(),
      if (description != null) 'description': description,
      'format': format.index,
      if (goodreads != null) 'goodreads': goodreads,
      if (isbn != null) 'isbn': isbn,
      if (language != null) 'language': language,
      if (lastRead != null) 'last_read': lastRead.toString(),
      if (libraryThing != null) 'library_thing': libraryThing,
      if (openLibrary != null) 'open_library': openLibrary,
      'page_count': pageCount,
      'parent_id': parentId,
      'path': path,
      if (publishDate != null) 'publish_date': publishDate.toString(),
      if (publisher != null) 'publisher': publisher,
      'reading_status': readingStatus.index,
      if (series != null) 'series': series,
      if (seriesIndex != null) 'series_index': seriesIndex,
      'subjects': subjects.join(","),
      if (subtitle != null) 'subtitle': subtitle,
      'title': title,
    };
  }

  Book.fromMap(super.map)
    : author = map['author']?.toString(),
      cover = map['cover']?.toString(),
      currentPage = int.parse(map['current_page'].toString()),
      description = map['description']?.toString(),
      format = BookFormat.values[int.parse(map['format'].toString())],
      goodreads = map['goodreads']?.toString(),
      isbn = map['isbn']?.toString(),
      language = map['language']?.toString(),
      lastRead = DateTime.tryParse(map['last_read'].toString()),
      libraryThing = map['library_thing']?.toString(),
      openLibrary = map['open_library']?.toString(),
      pageCount = int.parse(map['page_count'].toString()),
      publishDate = DateTime.tryParse(map['publish_date'].toString()),
      publisher = map['publisher']?.toString(),
      readingStatus =
          ReadingStatus.values[int.parse(map['reading_status'].toString())],
      series = map['series']?.toString(),
      seriesIndex = double.tryParse(map['series_index'].toString()),
      subjects = map['subjects'].toString().split(","),
      subtitle = map['subtitle']?.toString(),
      super.fromMap();
}
