import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/command.dart';
import '../../data/models/book_model.dart';
import '../../routing/routes.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    required this.setReadingStatus,
  });

  final BookModel book;
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
                return SizedBox();
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
