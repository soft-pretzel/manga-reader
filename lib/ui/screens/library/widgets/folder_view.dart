import 'package:flutter/material.dart';

import '../view_models/folder_view_model.dart';

class FolderView extends StatefulWidget {
  const FolderView({super.key, required this.viewModel});

  final FolderViewModel viewModel;

  @override
  State<FolderView> createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return Column(
          children: [
            AppBar(title: Text(widget.viewModel.folderName)),
            Expanded(
              child: RefreshIndicator(
                onRefresh: widget.viewModel.load.execute,
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
                          Text(
                            'Error loading folder \'${widget.viewModel.folderName}\'',
                          ),
                          TextButton(
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
                        return Center(child: Text('No books found'));
                      }

                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          children: [
                            for (final item in widget.viewModel.libraryItems)
                              item!.buildCard(context),
                          ],
                        ),
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
