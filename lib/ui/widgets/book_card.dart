import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/command.dart';
import '../../data/models/book_item.dart';
import '../../routing/routes.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    required this.setReadingStatus,
  });

  final BookItem book;
  final Command1<void, String> setReadingStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              child: () {
                if (book.thumbnail != null) {
                  return Image.file(File(book.thumbnail!));
                } else {
                  return SizedBox();
                }
              }(),
              onTap: () {
                setReadingStatus.execute(book.id);
                context.pushNamed(
                  RouteNames.reader,
                  pathParameters: {'bookId': book.id},
                );
              },
            ),
          ),
        ),
        Text(book.name),
      ],
    );
  }
}
