import 'package:flutter/widgets.dart';

import '../../../../data/models/book.dart';
import '../library_view_model.dart';

class BookTile2 extends StatelessWidget {
  const BookTile2({super.key, required this.book, required this.viewModel});

  final Book book;
  final LibraryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
