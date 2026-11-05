import 'package:flutter/material.dart';

import '../../../data/models/book.dart';
import '../../../data/models/folder.dart';
import 'library_view_model.dart';
import '../../widgets/error_screen.dart';
import 'widgets/book_grid_tile.dart';
import 'widgets/book_list_tile.dart';
import 'widgets/empty_library_screen.dart';
import 'widgets/folder_grid_tile.dart';
import 'widgets/folder_list_tile.dart';
import 'widgets/library_app_bar.dart';

class LibraryView extends StatelessWidget {
  final LibraryViewModel viewModel;

  const LibraryView({super.key, required this.viewModel});

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
                if (viewModel.addLocalFolder.running) {
                  return Center(child: CircularProgressIndicator());
                }
                if (viewModel.library.isEmpty) {
                  return EmptyLibraryScreen();
                }
                switch (viewModel.libraryDisplayMode) {
                  case .grid:
                    return GridView.builder(
                      clipBehavior: .antiAlias,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio:
                            viewModel.libraryDisplaySpacing == .comfortable
                            ? 0.534
                            : viewModel.libraryDisplaySpacing == .normal
                            ? 0.498
                            : 0.474,
                        crossAxisCount:
                            viewModel.libraryDisplaySpacing == .comfortable
                            ? 2
                            : viewModel.libraryDisplaySpacing == .normal
                            ? 3
                            : 4,
                        crossAxisSpacing:
                            viewModel.libraryDisplaySpacing == .comfortable
                            ? 24
                            : viewModel.libraryDisplaySpacing == .normal
                            ? 20
                            : 16,
                        mainAxisSpacing:
                            viewModel.libraryDisplaySpacing == .comfortable
                            ? 24
                            : viewModel.libraryDisplaySpacing == .normal
                            ? 20
                            : 16,
                      ),
                      itemBuilder: (context, index) {
                        if (viewModel.library[index].runtimeType == Folder) {
                          return FolderGridTile(
                            folder: viewModel.library[index] as Folder,
                            index: index,
                            viewModel: viewModel,
                          );
                        } else {
                          return BookGridTile(
                            book: viewModel.library[index] as Book,
                            index: index,
                            viewModel: viewModel,
                          );
                        }
                      },
                      itemCount: viewModel.library.length,
                      padding: .all(
                        viewModel.libraryDisplaySpacing == .comfortable
                            ? 24
                            : viewModel.libraryDisplaySpacing == .normal
                            ? 20
                            : 16,
                      ),
                    );
                  case .list:
                    return ListView.separated(
                      clipBehavior: .antiAlias,
                      itemBuilder: (context, index) {
                        if (viewModel.library[index].runtimeType == Folder) {
                          return FolderListTile(
                            folder: viewModel.library[index] as Folder,
                            index: index,
                            viewModel: viewModel,
                          );
                        } else {
                          return BookListTile(
                            book: viewModel.library[index] as Book,
                            index: index,
                            viewModel: viewModel,
                          );
                        }
                      },
                      itemCount: viewModel.library.length,
                      padding: .all(0),
                      separatorBuilder: (context, index) {
                        return Divider(height: 0);
                      },
                    );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
