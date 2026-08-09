import 'package:flutter/material.dart';

import 'library_view_model.dart';
import 'widgets/book_tile.dart';
import 'widgets/series_tile.dart';
import '../../../data/models/book.dart';
import '../../../data/models/series.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key, required this.viewModel});

  final LibraryViewModel viewModel;

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.viewModel.getTitle.execute();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.getTitle,
      builder: (context, _) {
        return Column(
          children: [
            AppBar(title: Text(widget.viewModel.title)),
            Expanded(
              child: RefreshIndicator(
                onRefresh: widget.viewModel.refresh.execute,
                child: ListenableBuilder(
                  listenable: widget.viewModel.load,
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

                    return child!;
                  },
                  child: ListenableBuilder(
                    listenable: widget.viewModel,
                    builder: (context, _) {
                      if (widget.viewModel.libraryItems.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No books found'),
                            FilledButton(
                              onPressed: widget.viewModel.refresh.execute,
                              child: Text('Reload'),
                            ),
                          ],
                        );
                      }

                      return GridView.count(
                        padding: EdgeInsets.all(16),
                        crossAxisCount: 3,
                        childAspectRatio: .51,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 6,
                        children: [
                          for (final item in widget.viewModel.libraryItems)
                            if (item.runtimeType == Series)
                              SeriesTile(
                                series: item as Series,
                                viewModel: widget.viewModel,
                              )
                            else
                              BookTile(
                                book: item as Book,
                                viewModel: widget.viewModel,
                              ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
