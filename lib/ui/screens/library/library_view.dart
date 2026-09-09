import 'package:flutter/material.dart';

import '../../widgets/empty_screen.dart';
import '../../widgets/error_screen.dart';
import 'library_view_model.dart';
import 'widgets/book_tile.dart';
import 'widgets/series_tile.dart';
import '../../../data/models/book.dart';
import '../../../data/models/series.dart';

class LibraryView extends StatelessWidget {
  LibraryView({super.key, required this.viewModel});

  final LibraryViewModel viewModel;
  final _menuContoroller = MenuController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) => Text(viewModel.title),
          ),
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
                    viewModel.scanFolder.execute();
                  },
                  child: Text('Rescan folder'),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: viewModel.refresh.execute,
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                if (viewModel.refresh.running) {
                  return SizedBox.shrink();
                }
                if (viewModel.refresh.error) {
                  return ErrorScreen(
                    function: viewModel.refresh.execute,
                    text: 'Error loading Library',
                  );
                }
                if (viewModel.library.isEmpty) {
                  return EmptyScreen(
                    function: viewModel.scanFolder.execute,
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
                    final item = viewModel.library[index];
                    if (item.runtimeType == Series) {
                      return SeriesTile(
                        series: item as Series,
                        viewModel: viewModel,
                      );
                    } else {
                      return BookTile(book: item as Book, viewModel: viewModel);
                    }
                  },
                  itemCount: viewModel.library.length,
                  padding: EdgeInsets.all(16),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
