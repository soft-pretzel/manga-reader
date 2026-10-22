import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'folder_menu.dart';
import '../library_view_model.dart';
import '../../../../data/models/folder.dart';
import '../../../../routing/routes.dart';

class FolderTile extends StatelessWidget {
  FolderTile({super.key, required this.folder, required this.viewModel});

  final Folder folder;
  final LibraryViewModel viewModel;
  final _menuController = MenuController();

  void _handleLongPress(LongPressStartDetails details) {
    _menuController.open(position: details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: GestureDetector(
              onLongPressStart: (details) => _handleLongPress(details),
              onTap: () {
                context.pushNamed(
                  RouteNames.folder,
                  pathParameters: {'folderId': folder.id},
                );
              },
              child: MenuAnchor(
                animated: true,
                controller: _menuController,
                menuChildren: [
                  MenuItemButton(
                    onPressed: () {},
                    trailingIcon: Icon(Icons.more_horiz),
                    child: Text('Details'),
                  ),
                  MenuItemButton(
                    onPressed: () {},
                    trailingIcon: Icon(Icons.cached),
                    child: Text('Rescan'),
                  ),
                  MenuItemButton(
                    onPressed: () =>
                        viewModel.deleteLocalFolder.execute(folder.id),
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(
                        ColorScheme.of(context).error,
                      ),
                      iconColor: WidgetStatePropertyAll(
                        ColorScheme.of(context).error,
                      ),
                    ),
                    trailingIcon: Icon(Icons.delete_outline),
                    child: Text('Delete'),
                  ),
                ],
                child: Card(
                  clipBehavior: .hardEdge,
                  margin: EdgeInsets.all(0),
                  child: () {
                    if (folder.cover != null) {
                      return Image.file(File(folder.cover!));
                    }
                  }(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .end,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: .ellipsis,
                  text: TextSpan(text: folder.name),
                ),
                Text(
                  folder.itemCount == 1
                      ? '${folder.itemCount} item'
                      : '${folder.itemCount} items',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
