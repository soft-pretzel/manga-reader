import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'library_view_model.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key, required this.viewModel});

  final LibraryViewModel viewModel;

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          children: [
            AppBar(title: Text('Library')),
            Expanded(
              child: Padding(
                padding: EdgeInsetsGeometry.all(24),
                child: Column(
                  children: [
                    ListenableBuilder(
                      listenable: widget.viewModel,
                      builder: (context, child) {
                        if (widget.viewModel.loadFolders.error) {
                          return Center(
                            child: ErrorWidget(
                              widget.viewModel.loadFolders.error,
                            ),
                          );
                        }

                        widget.viewModel.loadBooks.execute();
                        final books = widget.viewModel.books;

                        if (books != null) {
                          if (books.isEmpty) {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  'Add a folder with the button below',
                                ),
                              ),
                            );
                          } else {
                            return Expanded(
                              child: GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.6,
                                children: [
                                  for (final book in books)
                                    GestureDetector(
                                      onTap: () async {
                                        await widget.viewModel.setCurrentBook
                                            .execute(book.id);
                                        context.push('/reader');
                                      },
                                      child: Column(
                                        children: [
                                          Card(
                                            clipBehavior: Clip.antiAlias,
                                            child: Image.file(
                                              File(book.thumbnail!),
                                            ),
                                          ),
                                          Text(book.name),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }
                        }

                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              widget.viewModel.addFolder.execute();
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
