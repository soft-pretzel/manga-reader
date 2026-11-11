import 'book.dart';
import 'library_item.dart';
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
  if (a.title.replaceAll(RegExp(r'[^0-9]'), '') != '') {
    return int.parse(
      a.title.replaceAll(RegExp(r'[^0-9]'), ''),
    ).compareTo(int.parse(b.title.replaceAll(RegExp(r'[^0-9]'), '')));
  } else {
    return a.title.compareTo(b.title);
  }
}
