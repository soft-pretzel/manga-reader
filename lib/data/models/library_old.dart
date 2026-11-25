import 'book.dart';
import 'folder.dart';
import 'opds_feed.dart';
import 'settings.dart';

final class Library {
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
        items.sort((a, b) => a.getDate().compareTo(b.getDate()));
      case .dateAddedReverse:
        items.sort((b, a) => a.getDate().compareTo(b.getDate()));
    }
  }

  static int _sortAlphabetically(LibraryItem a, LibraryItem b) {
    if (a.getName().replaceAll(RegExp(r'[^0-9]'), '') != '') {
      return int.parse(a.getName().replaceAll(RegExp(r'[^0-9]'), ''))
          .compareTo(int.parse(b.getName().replaceAll(RegExp(r'[^0-9]'), '')));
    } else {
      return a.getName().compareTo(b.getName());
    }
  }
}

abstract class LibraryItem {
  DateTime getDate() {
    switch (runtimeType) {
      case Book:
        final book = this as Book;
        return book.dateAdded;
      case Folder:
        final folder = this as Folder;
        return folder.dateAdded;
      case OpdsFeed:
        final server = this as OpdsFeed;
        return server.feed!.updated!;
      default:
        throw Exception('Library Error: Invalid library item type');
    }
  }

  String getName() {
    switch (runtimeType) {
      case Book:
        final book = this as Book;
        return book.title;
      case Folder:
        final folder = this as Folder;
        return folder.name;
      case OpdsFeed:
        final server = this as OpdsFeed;
        return server.feed?.title ?? '';
      default:
        throw Exception('Library Error: Invalid library item type');
    }
  }
}
