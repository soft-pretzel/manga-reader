import 'package:flutter/material.dart';

import '../library_view_model.dart';
import '../../../../data/models/book_model.dart';

class BookMenu extends StatefulWidget {
  const BookMenu({
    super.key,
    required this.status,
    required this.viewModel,
    required this.child,
  });

  final ReadingStatus status;
  final LibraryViewModel viewModel;
  final Widget child;

  @override
  State<BookMenu> createState() => _BookMenuState();
}

class _BookMenuState extends State<BookMenu> {
  final _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      animated: true,
      controller: _menuController,
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
