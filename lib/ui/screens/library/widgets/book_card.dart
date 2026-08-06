import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../library_view_model.dart';
import '../../../../data/models/book_model.dart';
import '../../../../routing/routes.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book, required this.viewModel});

  final BookModel book;
  final LibraryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 4,
          child: Card(
            margin: EdgeInsets.all(0),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              child: Thumbnail(book: book, viewModel: viewModel),
              onTap: () {
                context.pushNamed(
                  RouteNames.reader,
                  pathParameters: {'bookId': book.id},
                );
              },
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
                      text: book.name,
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

class Thumbnail extends StatefulWidget {
  const Thumbnail({super.key, required this.book, required this.viewModel});

  final BookModel book;
  final LibraryViewModel viewModel;

  @override
  State<Thumbnail> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.getBookThumbnails.execute();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.getBookThumbnails,
      builder: (context, child) {
        if (widget.viewModel.getBookThumbnails.error) {
          return Center(child: Text('Error'));
        }

        return child!;
      },
      child: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.book.thumbnail == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Image.file(File(widget.book.thumbnail!));
        },
      ),
    );
  }
}
