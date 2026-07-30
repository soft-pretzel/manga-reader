import 'package:flutter/material.dart';

import '../view_models/library_view_model.dart';

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
  }

  void addFolder() async {
    await widget.viewModel.addFolder.execute();
    if (widget.viewModel.snackBar != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            ),
            content: Text(widget.viewModel.snackBar!),
            duration: Duration(seconds: 2),
            persist: false,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text('Library'),
          actions: [IconButton(onPressed: addFolder, icon: Icon(Icons.add))],
        ),
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
                      Text('Error loading Library'),
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
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No folders found'),
                        TextButton(
                          onPressed: widget.viewModel.addFolder.execute,
                          child: Text('Add Folder'),
                        ),
                      ],
                    );
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
  }
}
