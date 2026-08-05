import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/book_model.dart';
import '../../routing/routes.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
  });

  final BookModel book;

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
