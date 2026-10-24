import 'dart:io';
import 'dart:math';

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
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: .bottomCenter,
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
                  // clipBehavior: .antiAlias,
                  margin: .all(0),
                  child: Stack(
                    children: [
                      folder.covers[2] != null
                          ? Transform.rotate(
                              angle: (pi / 180) * -4,
                              child: Card(
                                clipBehavior: .antiAlias,
                                margin: .all(0),
                                child: Image.file(
                                  File(folder.covers[2]!),
                                  isAntiAlias: true,
                                  opacity: AlwaysStoppedAnimation(0.4),
                                ),
                              ),
                            )
                          : SizedBox.expand(),
                      folder.covers[1] != null
                          ? Transform.rotate(
                              angle: (pi / 180) * 4,
                              child: Card(
                                clipBehavior: .antiAlias,
                                margin: .all(0),
                                child: Image.file(
                                  File(folder.covers[1]!),
                                  isAntiAlias: true,
                                  opacity: AlwaysStoppedAnimation(0.7),
                                ),
                              ),
                            )
                          : SizedBox.expand(),
                      folder.covers[0] != null
                          ? Card(
                              clipBehavior: .antiAlias,
                              margin: .all(0),
                              child: Image.file(
                                File(folder.covers[0]!),
                                isAntiAlias: true,
                              ),
                            )
                          : SizedBox.expand(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const .only(top: 4),
          child: SizedBox(
            width: .infinity,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: .ellipsis,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    text: folder.name,
                  ),
                ),
                RichText(
                  maxLines: 1,
                  overflow: .ellipsis,
                  text: TextSpan(
                    style: DefaultTextStyle.of(
                      context,
                    ).style.apply(color: ColorScheme.of(context).outline),
                    text: folder.itemCount == 1
                        ? '${folder.itemCount} item'
                        : '${folder.itemCount} items',
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
