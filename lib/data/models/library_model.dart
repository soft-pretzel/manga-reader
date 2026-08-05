abstract class LibraryModel {
  final String id;
  final DateTime dateAdded;
  String name;
  final String? seriesId;

  LibraryModel({
    required this.id,
    required this.dateAdded,
    required this.name,
    this.seriesId,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date_added': dateAdded.toString(),
      'name': name,
      'series_id': seriesId,
    };
  }

  LibraryModel.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      dateAdded = DateTime.parse(map['date_added'].toString()),
      name = map['name'].toString(),
      seriesId = map['series_id'].toString();
}
