import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/book.dart';
import '../../../../routing/routes.dart';
import '../home_view_model.dart';

class BookCard extends StatelessWidget {
  BookCard({super.key, required this.book, required this.viewModel});

  final Book book;
  final HomeViewModel viewModel;
  final _menuController = MenuController();

  void _handleLongPress(LongPressStartDetails details) {
    _menuController.open(position: details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: Align(
            alignment: .bottomCenter,
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
                menuChildren: [
                  MenuItemButton(
                    onPressed: () => viewModel.markAsFinished.execute(book.id),
                    child: Text('Mark as finished'),
                  ),
                  MenuItemButton(child: Text('Details')),
                ],
                child: Card(
                  clipBehavior: .antiAlias,
                  margin: .all(0),
                  child: Image.file(File(book.cover!)),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const .only(top: 6),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              RichText(
                maxLines: 1,
                overflow: .ellipsis,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  text: book.name,
                ),
              ),
              RichText(
                maxLines: 1,
                overflow: .ellipsis,
                text: TextSpan(
                  style: DefaultTextStyle.of(
                    context,
                  ).style.apply(color: ColorScheme.of(context).outline),
                  text: book.pageCount == 1
                      ? '${book.pageCount} page'
                      : '${book.pageCount} pages',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
