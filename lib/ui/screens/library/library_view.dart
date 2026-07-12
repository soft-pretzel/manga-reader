import 'package:flutter/material.dart';
import 'package:manga_reader/ui/screens/library/library_view_model.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key, required this.viewModel});

  final LibraryViewModel viewModel;

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(24),
      child: Column(
        children: [
          FilledButton(
            onPressed: () async {
              widget.viewModel.addFolder.execute();
            },
            child: Text('Add Folder'),
          ),
          ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, child) {
              if (widget.viewModel.loadFolders.running) {
                return const Center(child: CircularProgressIndicator());
              }

              if (widget.viewModel.loadFolders.error) {
                return Center(
                  child: ErrorWidget(widget.viewModel.loadFolders.error),
                );
              }

              final folders = widget.viewModel.folders;
              if (folders != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final folder in folders)
                      Card(
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(folder),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.viewModel.deleteFolder.execute(folder);
                                },
                                child: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
