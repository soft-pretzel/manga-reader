class Book {
  final String id;
  final DateTime dateAdded;
  String name;
  String? path;
  String? uri;
  String? series;
  DateTime? lastRead;
  String? thumbnail;

  Book({
    required this.id,
    required this.dateAdded,
    required this.name,
    this.path,
    this.uri,
    this.series,
    this.lastRead,
    this.thumbnail,
  }) : assert(path != null || uri != null);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date_added': dateAdded.toString(),
      'name': name,
      'path': path,
      'uri': uri,
      'series': series,
      'last_read': lastRead.toString(),
      'thumbnail': thumbnail,
    };
  }

  Book.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      dateAdded = DateTime.parse(map['date_added'].toString()),
      name = map['name'].toString(),
      path = map['path'].toString(),
      uri = map['uri'].toString(),
      series = map['series'].toString(),
      lastRead = DateTime.tryParse(map['last_read'].toString()),
      thumbnail = map['thumbnail'].toString();

  @override
  String toString() {
    return 'Book{id: $id, date_added: $dateAdded, name: $name}';
  }
}
