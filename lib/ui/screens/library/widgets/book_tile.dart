import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/book.dart';
import '../../../../routing/routes.dart';
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
    return Column(
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
                  clipBehavior: .antiAlias,
                  margin: .all(0),
                  child: Stack(
                    children: [
                      book.cover != null
                          ? Image.file(File(book.cover!))
                          : SizedBox.expand(),
                      book.readingStatus == .inProgress
                          ? Positioned.fill(
                              child: Align(
                                alignment: .bottomCenter,
                                child: Padding(
                                  padding: .all(8),
                                  child: Directionality(
                                    textDirection:
                                        viewModel.readingDirection ==
                                            .rightToLeft
                                        ? .rtl
                                        : .ltr,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: .all(.circular(6)),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 16,
                                            color: ColorScheme.of(
                                              context,
                                            ).surface.withAlpha(153),
                                            spreadRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: LinearProgressIndicator(
                                        backgroundColor: ColorScheme.of(
                                          context,
                                        ).surface.withAlpha(153),
                                        borderRadius: .all(.circular(2)),
                                        color: ColorScheme.of(context).primary,
                                        value: book.currentPage / book.length!,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      book.readingStatus == .finished
                          ? Positioned.fill(
                              child: Align(
                                alignment: .topRight,
                                child: Padding(
                                  padding: .all(4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 16,
                                          color: ColorScheme.of(
                                            context,
                                          ).surface.withAlpha(153),
                                          spreadRadius: 4,
                                        ),
                                      ],
                                      shape: BoxShape.circle,
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
        ),
        Padding(
          padding: .only(
            top: viewModel.libraryDisplayDensity == .comfortable
                ? 8
                : viewModel.libraryDisplayDensity == .normal
                ? 6
                : 4,
          ),
          child: SizedBox(
            width: .infinity,
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
        ),
      ],
    );
  }
}
