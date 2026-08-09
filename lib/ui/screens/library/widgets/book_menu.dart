import 'package:flutter/material.dart';

import '../library_view_model.dart';
import '../../../../data/models/book.dart';

class BookMenu extends StatefulWidget {
  const BookMenu({
    super.key,
    required this.menuController,
    required this.status,
    required this.viewModel,
    required this.child,
  });

  final MenuController menuController;
  final ReadingStatus status;
  final LibraryViewModel viewModel;
  final Widget child;

  @override
  State<BookMenu> createState() => _BookMenuState();
}

class _BookMenuState extends State<BookMenu> {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      animated: true,
      controller: widget.menuController,
      menuChildren: [
        if (widget.status == ReadingStatus.unread)
          MenuItemButton(onPressed: () {}, child: Text('Mark as finished'))
        else if (widget.status == ReadingStatus.inProgress) ...[
          MenuItemButton(onPressed: () {}, child: Text('Mark as finished')),
          MenuItemButton(onPressed: () {}, child: Text('Mark as unread')),
        ] else
          MenuItemButton(onPressed: () {}, child: Text('Mark as unread')),
        MenuItemButton(onPressed: () {}, child: Text('Details')),
      ],
      child: widget.child,
    );
  }
}
