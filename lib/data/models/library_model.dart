abstract class LibraryModel {
  final String id;
  final DateTime dateAdded;
  String name;
  final String? seriesId;
  String? thumbnail;

  LibraryModel({
    required this.id,
    required this.dateAdded,
    required this.name,
    this.seriesId,
    this.thumbnail,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date_added': dateAdded.toString(),
      'name': name,
      'series_id': seriesId,
      'thumbnail': thumbnail,
    };
  }

  LibraryModel.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      dateAdded = DateTime.parse(map['date_added'].toString()),
      name = map['name'].toString(),
      seriesId = map['series_id'].toString(),
      thumbnail = map['thumbnail'].toString();
}
