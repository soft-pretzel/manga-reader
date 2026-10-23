import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                  child: Stack(
                    children: [
                      folder.cover != null
                          ? Image.file(File(folder.cover!))
                          : SizedBox.expand(),
                      Align(
                        alignment: .bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorScheme.of(context).surface.withAlpha(224),
                                ColorScheme.of(context).surface.withAlpha(0),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(8, 64, 0, 4),
                            child: Text(
                              folder.itemCount == 1
                                  ? '${folder.itemCount} item'
                                  : '${folder.itemCount} items',
                              style: TextStyle(
                                color: ColorScheme.of(context).primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: RichText(
                maxLines: 2,
                overflow: .ellipsis,
                text: TextSpan(
                  style: TextStyle(fontWeight: .bold),
                  text: folder.name,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
