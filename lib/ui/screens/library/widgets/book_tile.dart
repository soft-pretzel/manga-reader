import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/book.dart';
import '../../../../routing/routes.dart';
import '../../../widgets/triangle_clipper.dart';
import '../library_view_model.dart';

class BookTile extends StatelessWidget {
  BookTile({super.key, required this.book, required this.viewModel});

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
        crossAxisAlignment: .start,
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
                menuChildren: [
                  MenuItemButton(
                    onPressed: () => book.readingStatus != .finished
                        ? viewModel.markAsFinished.execute(book.id)
                        : viewModel.markAsUnread.execute(book.id),
                    child: Text(
                      book.readingStatus != .finished
                          ? 'Mark as finished'
                          : 'Mark as unread',
                    ),
                  ),
                  MenuItemButton(child: Text('Details')),
                ],
                child: Card(
                  clipBehavior: .hardEdge,
                  margin: EdgeInsets.all(0),
                  child: Stack(
                    children: [
                      book.cover != null
                          ? Image.file(File(book.cover!))
                          : SizedBox.expand(),
                      book.readingStatus == .inProgress
                          ? Align(
                              alignment: .bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: .bottomCenter,
                                    colors: [
                                      ColorScheme.of(
                                        context,
                                      ).surface.withAlpha(224),
                                      ColorScheme.of(
                                        context,
                                      ).surface.withAlpha(0),
                                    ],
                                    end: .topStart,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    4,
                                    64,
                                    4,
                                    4,
                                  ),
                                  child: LinearProgressIndicator(
                                    value: book.currentPage / book.length!,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      book.readingStatus == .finished
                          ? Align(
                              alignment: .bottomRight,
                              child: ClipPath(
                                clipper: TriangleClipper(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: .bottomRight,
                                      colors: [
                                        ColorScheme.of(
                                          context,
                                        ).surface.withAlpha(224),
                                        ColorScheme.of(
                                          context,
                                        ).surface.withAlpha(0),
                                        ColorScheme.of(
                                          context,
                                        ).surface.withAlpha(0),
                                      ],
                                      end: .topLeft,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsetsGeometry.fromLTRB(
                                      64,
                                      64,
                                      4,
                                      4,
                                    ),
                                    child: Icon(
                                      Icons.task_alt,
                                      color: ColorScheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
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
                  text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    text: book.name,
                  ),
                ),
                Text(
                  book.pageCount == 1
                      ? '${book.pageCount} page'
                      : '${book.pageCount} pages',
                  style: TextStyle(color: ColorScheme.of(context).outline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
