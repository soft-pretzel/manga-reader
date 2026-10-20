import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'library_view_model.dart';
import '../../widgets/error_screen.dart';
import 'widgets/empty_library_screen.dart';
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
                  return EmptyLibraryScreen();
                }
                return GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  padding: EdgeInsets.all(16),
                  children: [
                    for (final library in viewModel.library)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Card(
                              margin: EdgeInsets.all(0),
                              child: Center(child: Icon(Icons.folder_outlined)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
                            child: Text(library.name),
                          ),
                        ],
                      ),
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
