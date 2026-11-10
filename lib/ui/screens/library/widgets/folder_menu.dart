import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/folder.dart';
import '../library_view_model.dart';

class FolderMenu extends StatelessWidget {
  final Folder folder;
  final int index;
  final MenuController menuController;
  final LibraryViewModel viewModel;
  final Widget? child;

  const FolderMenu({
    super.key,
    required this.folder,
    required this.index,
    required this.menuController,
    required this.viewModel,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      animated: true,
      controller: menuController,
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.pop();
                        viewModel.deleteLocalFolder.execute(folder);
                      },
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(
                          ColorScheme.of(context).error,
                        ),
                        iconColor: WidgetStatePropertyAll(
                          ColorScheme.of(context).error,
                        ),
                      ),
                      child: Text('Delete'),
                    ),
                  ],
                  content: Text(
                    'You\'re about to delete this folder from the app. This has no effect on files stored locally on this device.',
                  ),
                  title: Text('Are you sure?'),
                );
              },
            );
          },
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(
              ColorScheme.of(context).error,
            ),
            iconColor: WidgetStatePropertyAll(ColorScheme.of(context).error),
          ),
          trailingIcon: Icon(Icons.delete_outline_rounded),
          child: Text('Delete'),
        ),
      ],
      child: child,
    );
  }
}
