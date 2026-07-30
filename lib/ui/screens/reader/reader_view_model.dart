import 'package:flutter/foundation.dart';

import '../../../data/models/library_item.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class ReaderViewModel extends ChangeNotifier {
  ReaderViewModel({required this._libraryRepository}) {
    // openBook = Command0(_openBook)..execute();
  }

  final LibraryRepository _libraryRepository;

  List<String> _pages = [];
  List<String> get pages => _pages;

  late final Command0 openBook;

  // Future<Result<void>> _openBook() async {}
}
