import 'package:flutter/material.dart';
import 'package:manga_reader/data/models/book_item.dart';
import 'package:manga_reader/data/models/folder_item.dart';
import 'package:manga_reader/ui/widgets/book_card.dart';
import 'package:manga_reader/ui/screens/library/widgets/folder_card.dart';

import 'library_view_model.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key, required this.viewModel});

  final LibraryViewModel viewModel;

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  void addFolder() async {
    await widget.viewModel.addFolder.execute();
    if (widget.viewModel.snackBar != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            ),
            content: Text(widget.viewModel.snackBar!),
            duration: Duration(seconds: 3),
            persist: false,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return Column(
          children: [
            AppBar(
              title: Text(widget.viewModel.title),
              actions: [
                IconButton(onPressed: addFolder, icon: Icon(Icons.add)),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: widget.viewModel.load.execute,
                child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, child) {
                    if (widget.viewModel.load.running) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (widget.viewModel.load.error) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error loading Library'),
                          FilledButton(
                            onPressed: widget.viewModel.load.execute,
                            child: Text('Try Again'),
                          ),
                        ],
                      );
                    }

                    if (widget.viewModel.libraryItems.isEmpty) {
                      if (widget.viewModel.title == 'Library') {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No folders found'),
                            FilledButton(
                              onPressed: widget.viewModel.addFolder.execute,
                              child: Text('Add Folder'),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No books found'),
                            TextButton(
                              onPressed: widget.viewModel.load.execute,
                              child: Text('Reload'),
                            ),
                          ],
                        );
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: [
                          for (final item in widget.viewModel.libraryItems)
                            if (item.runtimeType == FolderItem)
                              FolderCard(folder: item as FolderItem)
                            else
                              BookCard(
                                book: item as BookItem,
                                setReadingStatus:
                                    widget.viewModel.setReadingStatus,
                              ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
