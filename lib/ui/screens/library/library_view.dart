import 'package:flutter/material.dart';

import 'widgets/book_card.dart';
import 'library_view_model.dart';
import 'widgets/series_card.dart';
import '../../../data/models/book_model.dart';
import '../../../data/models/series_model.dart';

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
                            TextButton(
                              onPressed: widget.viewModel.load.execute,
                              child: Text('Reload'),
                            ),
                          ],
                        );
                      }

                      return GridView.count(
                        padding: EdgeInsets.all(16),
                        crossAxisCount: 3,
                        childAspectRatio: 0.51,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 10,
                        children: [
                          for (final item in widget.viewModel.libraryItems)
                            if (item.runtimeType == SeriesModel)
                              SeriesCard(
                                series: item as SeriesModel,
                                viewModel: widget.viewModel,
                              )
                            else
                              BookCard(
                                book: item as BookModel,
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
