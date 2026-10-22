import 'package:flutter/material.dart';

import '../../../data/models/book.dart';
import '../../../data/models/folder.dart';
import 'library_view_model.dart';
import '../../widgets/error_screen.dart';
import 'widgets/book_tile.dart';
import 'widgets/book_tile_2.dart';
import 'widgets/empty_library_screen.dart';
import 'widgets/folder_tile.dart';
import 'widgets/library_app_bar.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key, required this.viewModel});

  final LibraryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LibraryAppBar(viewModel: viewModel),
        Expanded(
          child: RefreshIndicator(
            onRefresh: viewModel.load.execute,
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                if (viewModel.load.running) {
                  return SizedBox.shrink();
                }
                if (viewModel.load.error) {
                  return ErrorScreen(
                    function: viewModel.load.execute,
                    text: 'Error loading Library',
                  );
                }
                if (viewModel.library.isEmpty) {
                  return EmptyLibraryScreen();
                }
                return GridView.count(
                  childAspectRatio: 0.53,
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  padding: EdgeInsets.all(16),
                  children: [
                    for (final item in viewModel.library)
                      if (item.runtimeType == Folder)
                        FolderTile(folder: item as Folder, viewModel: viewModel)
                      else
                        BookTile2(book: item as Book, viewModel: viewModel),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
