import 'package:flutter/material.dart';

import '../../widgets/empty_screen.dart';
import '../../widgets/error_screen.dart';
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
  late final MenuController _menuContoroller;

  @override
  void initState() {
    super.initState();
    _menuContoroller = MenuController();
  }

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
            AppBar(
              title: Text(widget.viewModel.title),
              actions: [
                MenuAnchor(
                  builder: (context, controller, child) {
                    return IconButton(
                      onPressed: _menuContoroller.open,
                      icon: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                  controller: _menuContoroller,
                  menuChildren: [
                    MenuItemButton(
                      onPressed: () {
                        widget.viewModel.scanFolder.execute();
                      },
                      child: Text('Rescan folder'),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: widget.viewModel.load.execute,
                child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, child) {
                    if (widget.viewModel.load.running) {
                      return SizedBox.shrink();
                    }
                    if (widget.viewModel.load.error) {
                      return ErrorScreen(
                        function: widget.viewModel.load.execute,
                        text: 'Error loading Library',
                      );
                    }
                    if (widget.viewModel.library.isEmpty) {
                      return EmptyScreen(
                        function: widget.viewModel.scanFolder.execute,
                        text: 'No books found',
                      );
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: .51,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 6,
                      ),
                      itemBuilder: (context, index) {
                        final item = widget.viewModel.library[index];
                        if (item.runtimeType == Series) {
                          return SeriesTile(
                            series: item as Series,
                            viewModel: widget.viewModel,
                          );
                        } else {
                          return BookTile(
                            book: item as Book,
                            viewModel: widget.viewModel,
                          );
                        }
                      },
                      itemCount: widget.viewModel.library.length,
                      padding: EdgeInsets.all(16),
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
