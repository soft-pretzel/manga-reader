import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/book.dart';
import '../../../../routing/routes.dart';
import '../library_view_model.dart';
import 'book_menu.dart';

class BookListTile extends StatelessWidget {
  BookListTile({
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
    return SizedBox(
      height: switch (viewModel.libraryDisplaySpacing) {
        .comfortable => 120,
        .normal => 104,
        .compact => 88,
      },
      child: Container(
        color: viewModel.selected[index]
            ? ColorScheme.of(context).surfaceBright.withAlpha(128)
            : null,
        child: GestureDetector(
          behavior: .translucent,
          onLongPressStart: (details) {
            if (!viewModel.isSelectionMode) _handleLongPress(details);
          },
          child: InkWell(
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
              child: Stack(
                children: [
                  if (book.readingStatus == .inProgress)
                    Directionality(
                      textDirection: viewModel.readingDirection == .rightToLeft
                          ? .rtl
                          : .ltr,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        minHeight: .infinity,
                        value: book.currentPage / book.pageCount!,
                        valueColor: AlwaysStoppedAnimation(
                          ColorScheme.of(context).primary.withAlpha(24),
                        ),
                      ),
                    ),
                  Padding(
                    padding: switch (viewModel.libraryDisplaySpacing) {
                      .comfortable => .symmetric(horizontal: 24, vertical: 12),
                      .normal => .symmetric(horizontal: 20, vertical: 10),
                      .compact => .symmetric(horizontal: 16, vertical: 8),
                    },
                    child: Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Center(
                                child: book.cover == null
                                    ? CircularProgressIndicator()
                                    : book.cover != ''
                                    ? Image.file(
                                        File(book.cover!),
                                        color: viewModel.selected[index]
                                            ? ColorScheme.of(
                                                context,
                                              ).surfaceBright.withAlpha(128)
                                            : null,
                                        colorBlendMode: .srcOver,
                                      )
                                    : SizedBox(),
                              ),
                              if (viewModel.selected[index])
                                Center(
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    color: ColorScheme.of(context).primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: .start,
                            mainAxisAlignment: .center,
                            spacing: 4,
                            children: [
                              RichText(
                                maxLines: 1,
                                overflow: .ellipsis,
                                text: TextSpan(
                                  style: TextTheme.of(context).bodyLarge,
                                  text: book.title,
                                ),
                              ),
                              if (book.author != null)
                                RichText(
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                  text: TextSpan(
                                    style: TextTheme.of(context).bodyMedium!
                                        .apply(
                                          color: ColorScheme.of(
                                            context,
                                          ).outline,
                                        ),
                                    text: book.author,
                                  ),
                                ),
                              RichText(
                                maxLines: 1,
                                overflow: .ellipsis,
                                text: TextSpan(
                                  style: TextTheme.of(context).bodyMedium!
                                      .apply(
                                        color: ColorScheme.of(context).outline,
                                      ),
                                  text: book.pageCount == 1
                                      ? '${book.pageCount} page'
                                      : '${book.pageCount} pages',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            switch (book.readingStatus) {
                              .unread => 'Unread',
                              .inProgress =>
                                '${(book.currentPage / book.pageCount! * 100).round()}%',
                              .finished => 'Finished',
                            },
                            textAlign: .end,
                            style: TextTheme.of(context).bodyMedium!.apply(
                              color: switch (book.readingStatus) {
                                .unread => ColorScheme.of(context).outline,
                                .inProgress => ColorScheme.of(
                                  context,
                                ).onSurface,
                                .finished => ColorScheme.of(context).primary,
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
