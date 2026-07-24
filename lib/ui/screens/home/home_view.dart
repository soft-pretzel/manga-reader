import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(title: Text('Home')),
        SafeArea(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, child) {
              if (widget.viewModel.load.running) {
                return Center(child: CircularProgressIndicator());
              }

              final inProgressBooks = widget.viewModel.inProgressBooks;
              if (inProgressBooks.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Continue Reading'),
                      SizedBox(
                        height: 400,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (final book in inProgressBooks)
                              Column(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        await widget.viewModel.setCurrentBook
                                            .execute(book.id);
                                        context.push('/reader');
                                      },
                                      child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.file(
                                          File(book.thumbnail!),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(book.name),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
