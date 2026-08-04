import 'library_model.dart';

class SeriesModel extends LibraryModel {
  SeriesModel({
    required super.id,
    required super.dateAdded,
    required super.name,
  });

  SeriesModel.fromMap(super.map) : super.fromMap();
}
