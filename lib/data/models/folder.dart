import 'library.dart';
import 'settings.dart';

class Folder extends Library {
  List<String?> covers;
  List<Library> items;

  Folder({
    required super.id,
    this.covers = const [],
    required super.dateAdded,
    this.items = const [],
    super.parentId,
    required super.path,
    required super.title,
  });

  Folder.fromMap(super.map)
    : covers = List.filled(3, null),
      items = [],
      super.fromMap();

  void sort(LibrarySort sort) {
    List<Library> items = List.from(this.items);
    switch (sort) {
      case .alphabetical:
        items.sort((a, b) => _sortAlphabetically(a, b));
      case .alphabeticalReverse:
        items.sort((b, a) => _sortAlphabetically(a, b));
      case .dateAdded:
        items.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
      case .dateAddedReverse:
        items.sort((b, a) => a.dateAdded.compareTo(b.dateAdded));
      case .lastRead:
      case .lastReadReverse:
    }
    this.items = items;
  }
}

int _sortAlphabetically(Library a, Library b) {
  if (a.title.replaceAll(RegExp(r'[^0-9]'), '') != '' &&
      b.title.replaceAll(RegExp(r'[^0-9]'), '') != '') {
    return int.parse(
      a.title.replaceAll(RegExp(r'[^0-9]'), ''),
    ).compareTo(int.parse(b.title.replaceAll(RegExp(r'[^0-9]'), '')));
  } else {
    return a.title.compareTo(b.title);
  }
}
