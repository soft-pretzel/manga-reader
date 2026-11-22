import 'book.dart';
import 'folder.dart';
import 'library_item.dart';
import 'server.dart';
import 'settings.dart';

class Library {
  final List<LibraryItem> items;
  final String title;

  Library({required this.items, required this.title});

  void filter(List<ReadingStatus> filter) {
    if (filter.isNotEmpty) {
      items.removeWhere((item) {
        if (item.runtimeType == Book) {
          final book = item as Book;
          return !filter.contains(book.readingStatus);
        } else {
          return false;
        }
      });
    }
  }

  void sort(LibrarySort sort) {
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
  }
}

int _sortAlphabetically(LibraryItem a, LibraryItem b) {
  String aString;
  switch (a.runtimeType) {
    case Book:
      a as Book;
      aString = a.title;
    case Folder:
      a as Folder;
      aString = a.name;
    case Server:
      a as Server;
      aString = a.feed!.title;
    default:
      throw Exception;
  }
  String bString;
  switch (b.runtimeType) {
    case Book:
      b as Book;
      bString = b.title;
    case Folder:
      b as Folder;
      bString = b.name;
    case Server:
      b as Server;
      bString = b.feed!.title;
    default:
      throw Exception;
  }
  if (aString.replaceAll(RegExp(r'[^0-9]'), '') != '') {
    return int.parse(aString.replaceAll(RegExp(r'[^0-9]'), ''))
        .compareTo(int.parse(bString.replaceAll(RegExp(r'[^0-9]'), '')));
  } else {
    return aString.compareTo(bString);
  }
}
