import 'library.dart';

class Series extends Library {
  int? bookCount;

  Series({
    required super.id,
    this.bookCount,
    required super.dateAdded,
    required super.name,
    super.seriesId,
    super.thumbnail,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'book_count': bookCount,
      'date_added': dateAdded.toString(),
      'name': name,
      'series_id': seriesId,
      'thumbnail': thumbnail,
    };
  }

  Series.fromMap(super.map)
    : bookCount = int.tryParse(map['book_count'].toString()),
      super.fromMap();
}
