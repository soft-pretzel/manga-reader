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
    if (!viewModel.parseLocalFolder.running) {
      if (folder.covers.elementAtOrNull(0) == null) {
        viewModel.getFolderCover1.execute(folder);
      } else if (folder.covers[0] != '') {
        if (!File(folder.covers[0]!).existsSync()) {
          viewModel.getFolderCover1.execute(folder);
        }
      }
      if (folder.covers.elementAtOrNull(1) == null) {
        viewModel.getFolderCover2.execute(folder);
      } else if (folder.covers[1] != '') {
        if (!File(folder.covers[1]!).existsSync()) {
          viewModel.getFolderCover2.execute(folder);
        }
      }
      if (folder.covers.elementAtOrNull(2) == null) {
        viewModel.getFolderCover3.execute(folder);
      } else if (folder.covers[2] != '') {
        if (!File(folder.covers[2]!).existsSync()) {
          viewModel.getFolderCover3.execute(folder);
        }
      }
    }
    print(viewModel.parseLocalFolder.running);
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
                child: Stack(
                  children: [
                    Transform.rotate(
                      angle: (pi / 180) * -4,
                      child: Card(
                        clipBehavior: .antiAlias,
                        color: ColorScheme.of(context).surfaceContainerLow,
                        margin: .all(0),
                        child: viewModel.getFolderCover3.running
                            ? SizedBox.expand()
                            : folder.covers[2] == ''
                            ? SizedBox.expand()
                            : Image.file(
                                File(folder.covers[2]!),
                                isAntiAlias: true,
                                opacity: AlwaysStoppedAnimation(0.4),
                              ),
                      ),
                    ),
                    Transform.rotate(
                      angle: (pi / 180) * 4,
                      child: Card(
                        clipBehavior: .antiAlias,
                        color: ColorScheme.of(context).surfaceContainer,
                        margin: .all(0),
                        child: viewModel.getFolderCover2.running
                            ? SizedBox.expand()
                            : folder.covers[1] == ''
                            ? SizedBox.expand()
                            : Image.file(
                                File(folder.covers[1]!),
                                isAntiAlias: true,
                                opacity: AlwaysStoppedAnimation(0.7),
                              ),
                      ),
                    ),
                    Card(
                      clipBehavior: .antiAlias,
                      color: ColorScheme.of(context).surfaceContainerHigh,
                      margin: .all(0),
                      child:
                          viewModel.getFolderCover1.running ||
                              viewModel.parseLocalFolder.running
                          ? SizedBox.expand(
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : folder.covers[0] == ''
                          ? SizedBox.expand()
                          : Image.file(
                              File(folder.covers[0]!),
                              isAntiAlias: true,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: .only(
            top: viewModel.libraryDisplayDensity == .comfortable
                ? 8
                : viewModel.libraryDisplayDensity == .normal
                ? 6
                : 4,
          ),
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
