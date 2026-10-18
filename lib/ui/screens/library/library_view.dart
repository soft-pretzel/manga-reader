import 'package:flutter/material.dart';

import 'library_view_model.dart';
import 'widgets/book_tile.dart';
import 'widgets/folder_tile.dart';
import '../../widgets/error_screen.dart';
import '../../../data/models/book.dart';
import '../../../data/models/folder.dart';

class LibraryView extends StatelessWidget {
  LibraryView({super.key, required this.viewModel});

  final LibraryViewModel viewModel;

  final _menuController = MenuController();

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
                  onPressed: _menuController.open,
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
              controller: _menuController,
              menuChildren: [
                MenuItemButton(onPressed: () {}, child: Text('Select all')),
                MenuItemButton(onPressed: () {}, child: Text('Sort by...')),
              ],
            ),
          ],
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: viewModel.refresh.execute,
            child: Stack(
              children: [
                ListenableBuilder(
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
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: constraints.maxHeight,
                              width: constraints.maxWidth,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.menu_book_outlined,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 64,
                                  ),
                                  SizedBox(height: 12),
                                  Text('Add a library source'),
                                ],
                              ),
                            ),
                          );
                        },
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
                        if (item.runtimeType == Folder) {
                          return FolderTile(
                            series: item as Folder,
                            viewModel: viewModel,
                          );
                        } else {
                          return BookTile(
                            book: item as Book,
                            viewModel: viewModel,
                          );
                        }
                      },
                      itemCount: viewModel.library.length,
                      padding: EdgeInsets.all(16),
                    );
                  },
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            children: [
                              TextButton.icon(
                                icon: Icon(Icons.folder),
                                label: Text('Local folder'),
                                onPressed: () {},
                              ),
                              TextButton.icon(
                                icon: Icon(Icons.book),
                                label: Text('OPDS server'),
                                onPressed: () {},
                              ),
                              TextButton.icon(
                                icon: Icon(Icons.cloud),
                                label: Text('Cloud drive'),
                                onPressed: () {},
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
