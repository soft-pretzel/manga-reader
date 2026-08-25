import 'package:flutter/material.dart';

import '../library_view_model.dart';
import '../../../../data/models/book.dart';

class BookMenu extends StatefulWidget {
  const BookMenu({
    super.key,
    required this.book,
    required this.menuController,
    required this.viewModel,
    required this.child,
  });

  final Book book;
  final MenuController menuController;
  final LibraryViewModel viewModel;
  final Widget child;

  @override
  State<BookMenu> createState() => _BookMenuState();
}

class _BookMenuState extends State<BookMenu> {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: widget.menuController,
      menuChildren: [
        if (widget.book.readingStatus == ReadingStatus.unread)
          MenuItemButton(
            onPressed: () {
              widget.viewModel.markAsFinished.execute(widget.book);
            },
            child: Text('Mark as finished'),
          )
        else if (widget.book.readingStatus == ReadingStatus.inProgress) ...[
          MenuItemButton(
            onPressed: () {
              widget.viewModel.markAsFinished.execute(widget.book);
            },
            child: Text('Mark as finished'),
          ),
          MenuItemButton(
            onPressed: () {
              widget.viewModel.markAsUnread.execute(widget.book);
            },
            child: Text('Mark as unread'),
          ),
        ] else
          MenuItemButton(
            onPressed: () {
              widget.viewModel.markAsUnread.execute(widget.book);
            },
            child: Text('Mark as unread'),
          ),
        MenuItemButton(onPressed: () {}, child: Text('Details')),
      ],
      child: widget.child,
    );
  }
}
