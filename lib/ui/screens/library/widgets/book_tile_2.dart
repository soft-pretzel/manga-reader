import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/book.dart';
import '../../../../routing/routes.dart';
import '../library_view_model.dart';

class BookTile2 extends StatelessWidget {
  BookTile2({super.key, required this.book, required this.viewModel});

  final Book book;
  final LibraryViewModel viewModel;
  final _menuController = MenuController();

  void _handleLongPress(LongPressStartDetails details) {
    _menuController.open(position: details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: GestureDetector(
              onLongPressStart: (details) => _handleLongPress(details),
              onTap: () {
                context.pushNamed(
                  RouteNames.reader,
                  pathParameters: {'bookId': book.id},
                );
              },
              child: MenuAnchor(
                animated: true,
                controller: _menuController,
                menuChildren: [MenuItemButton()],
                child: Card(
                  clipBehavior: .hardEdge,
                  margin: EdgeInsets.all(0),
                  child: () {
                    if (book.cover != null) {
                      return Image.file(File(book.cover!));
                    }
                  }(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .end,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: .ellipsis,
                  text: TextSpan(text: book.name),
                ),
                Text('${book.pageCount} pages'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
