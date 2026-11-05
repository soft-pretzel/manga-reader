import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/book.dart';
import '../../../../routing/routes.dart';
import '../library_view_model.dart';
import 'book_menu.dart';

class BookGridTile extends StatelessWidget {
  BookGridTile({
    super.key,
    required this.book,
    required this.index,
    required this.viewModel,
  });

  final Book book;
  final int index;
  final LibraryViewModel viewModel;
  final _menuController = MenuController();

  void _handleLongPress(LongPressStartDetails details) {
    _menuController.open(position: details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    if (book.cover == null) {
      viewModel.getBookCover.execute(book);
    } else if (book.cover != '') {
      if (!File(book.cover!).existsSync()) {
        viewModel.getBookCover.execute(book);
      }
    }
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: .bottomCenter,
            child: GestureDetector(
              onLongPressStart: (details) {
                if (!viewModel.isSelectionMode) _handleLongPress(details);
              },
              onTap: () {
                if (viewModel.isSelectionMode) {
                  viewModel.toggleSelect.execute(index);
                } else {
                  context.pushNamed(
                    RouteNames.reader,
                    pathParameters: {'bookId': book.id},
                  );
                }
              },
              child: BookMenu(
                book: book,
                index: index,
                menuController: _menuController,
                viewModel: viewModel,
                child: Card(
                  clipBehavior: .antiAlias,
                  margin: .all(0),
                  child: Stack(
                    children: [
                      viewModel.getBookCover.running
                          ? SizedBox.expand(
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : book.cover != null && book.cover != ''
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
                                        borderRadius: .all(.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 8,
                                            color: ColorScheme.of(
                                              context,
                                            ).surface.withAlpha(153),
                                            spreadRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: LinearProgressIndicator(
                                        backgroundColor: ColorScheme.of(
                                          context,
                                        ).surface.withAlpha(153),
                                        borderRadius: .all(.circular(2)),
                                        color: ColorScheme.of(context).primary,
                                        value:
                                            book.currentPage / book.pageCount,
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
                                  padding: .all(8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 8,
                                          color: ColorScheme.of(
                                            context,
                                          ).surface.withAlpha(153),
                                          spreadRadius: 8,
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.task_alt_rounded,
                                      color: ColorScheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      if (viewModel.selected[index])
                        Positioned.fill(
                          child: Container(
                            color: ColorScheme.of(
                              context,
                            ).surface.withAlpha(128),
                            child: Center(
                              child: Icon(
                                Icons.check_circle,
                                color: ColorScheme.of(context).primary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: .only(
            top: viewModel.libraryDisplaySpacing == .comfortable
                ? 8
                : viewModel.libraryDisplaySpacing == .normal
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
                    text: book.title,
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
