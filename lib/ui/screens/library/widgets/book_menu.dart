import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/book.dart';
import '../../../../routing/routes.dart';
import '../library_view_model.dart';

class BookMenu extends StatelessWidget {
  final Book book;
  final int index;
  final MenuController menuController;
  final LibraryViewModel viewModel;
  final Widget? child;

  const BookMenu({
    super.key,
    required this.book,
    required this.index,
    required this.menuController,
    required this.viewModel,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      animated: true,
      controller: menuController,
      menuChildren: [
        MenuItemButton(
          onPressed: () => switch (book.readingStatus) {
            .finished => viewModel.markAsUnread.execute(book),
            _ => viewModel.markAsFinished.execute(book),
          },
          trailingIcon: Icon(switch (book.readingStatus) {
            .finished => Icons.replay_rounded,
            _ => Icons.task_alt_rounded,
          }),
          child: Text(switch (book.readingStatus) {
            .finished => 'Mark as unread',
            _ => 'Mark as finished',
          }),
        ),
        MenuItemButton(
          onPressed: () {
            viewModel.toggleSelect.execute(index);
          },
          trailingIcon: Icon(Icons.check_circle_outline_rounded),
          child: Text('Select'),
        ),
        MenuItemButton(
          onPressed: () {
            context.pushNamed(
              RouteNames.book,
              pathParameters: {'bookId': book.id},
            );
          },
          trailingIcon: Icon(Icons.more_vert),
          child: Text('Details'),
        ),
      ],
      child: child,
    );
  }
}
