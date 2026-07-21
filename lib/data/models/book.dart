enum BookType { book, comic, pdf }

class Book {
  final String id;
  final String name;
  final BookType bookType;
  final DateTime dateAdded;
  String path;
  String? thumbnail;
  String? series;
  DateTime? lastRead;
  int? currentPage;

  Book({
    required this.id,
    required this.name,
    required this.bookType,
    required this.dateAdded,
    required this.path,
    this.thumbnail,
    this.series,
    this.lastRead,
    this.currentPage,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'book_type': bookType.toString(),
      'date_added': dateAdded.toString(),
      'path': path,
      'thumbnail': thumbnail,
      'series': series,
      'last_read': lastRead.toString(),
      'current_page': currentPage,
    };
  }

  Book.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      name = map['name'].toString(),
      bookType = BookType.values.byName(
        map['book_type'].toString().split('.').last,
      ),
      dateAdded = DateTime.parse(map['date_added'].toString()),
      path = map['path'].toString(),
      thumbnail = map['thumbnail'].toString(),
      series = map['series'].toString(),
      lastRead = DateTime.tryParse(map['last_read'].toString()),
      currentPage = int.tryParse(map['current_page'].toString());

  @override
  String toString() {
    return 'Book{id: $id, name: $name, book_type: $bookType, date_added: $dateAdded}';
  }
}
