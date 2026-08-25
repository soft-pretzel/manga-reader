import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'book_menu.dart';
import 'thumbnail.dart';
import '../library_view_model.dart';
import '../../../../data/models/book.dart';
import '../../../../routing/routes.dart';

class BookTile extends StatefulWidget {
  const BookTile({super.key, required this.book, required this.viewModel});

  final Book book;
  final LibraryViewModel viewModel;

  @override
  State<BookTile> createState() => _BookTileState();
}

class _BookTileState extends State<BookTile> {
  final _menuController = MenuController();

  void _handleLongPress(LongPressStartDetails details) {
    _menuController.open(position: details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 4,
          child: Card(
            margin: EdgeInsets.all(0),
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              onTap: () {
                context.pushNamed(
                  RouteNames.reader,
                  pathParameters: {'bookId': widget.book.id},
                );
              },
              onLongPressStart: _handleLongPress,
              child: BookMenu(
                book: widget.book,
                menuController: _menuController,
                viewModel: widget.viewModel,
                child: Stack(
                  children: [
                    Thumbnail(item: widget.book, viewModel: widget.viewModel),
                    (widget.book.readingStatus == ReadingStatus.inProgress)
                        ? Align(
                            alignment: AlignmentGeometry.bottomCenter,
                            child: LinearProgressIndicator(
                              value:
                                  widget.book.currentPage / widget.book.length!,
                            ),
                          )
                        : SizedBox(),
                    (widget.book.readingStatus == ReadingStatus.finished)
                        ? Align(
                            alignment: AlignmentGeometry.bottomRight,
                            child: ClipPath(
                              clipper: TriangleClipper(),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                    colors: [
                                      Theme.of(
                                        context,
                                      ).colorScheme.surface.withAlpha(224),
                                      Theme.of(
                                        context,
                                      ).colorScheme.surface.withAlpha(0),
                                      Theme.of(
                                        context,
                                      ).colorScheme.surface.withAlpha(0),
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    64,
                                    64,
                                    4,
                                    4,
                                  ),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Align(
            alignment: AlignmentGeometry.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Wrap(
                children: [
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      text: widget.book.name,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // No need to redraw the shape unless it changes.
  }
}
