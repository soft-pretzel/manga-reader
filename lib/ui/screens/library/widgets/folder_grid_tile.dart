import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../library_view_model.dart';
import '../../../../data/models/folder.dart';
import '../../../../routing/routes.dart';
import 'folder_menu.dart';

class FolderGridTile extends StatelessWidget {
  FolderGridTile({
    super.key,
    required this.folder,
    required this.index,
    required this.viewModel,
  });

  final Folder folder;
  final int index;
  final LibraryViewModel viewModel;
  final _menuController = MenuController();

  void _handleLongPress(LongPressStartDetails details) {
    _menuController.open(position: details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    if (!folder.parsing) {
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
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: .bottomCenter,
            child: GestureDetector(
              onLongPressStart: (details) {
                if (!viewModel.isSelectionMode) _handleLongPress(details);
              },
              onTap: () {
                if (!folder.parsing &&
                    !viewModel.getFolderCover1.running &&
                    !viewModel.getFolderCover2.running &&
                    !viewModel.getFolderCover3.running) {
                  context.pushNamed(
                    RouteNames.folder,
                    pathParameters: {'folderId': folder.id},
                  );
                }
              },
              child: FolderMenu(
                folder: folder,
                index: index,
                menuController: _menuController,
                viewModel: viewModel,
                child: Stack(
                  children: [
                    Transform.rotate(
                      angle: (pi / 180) * -4,
                      child: Card(
                        clipBehavior: .antiAlias,
                        color: ColorScheme.of(context).surfaceContainer,
                        margin: .all(0),
                        child:
                            folder.covers.elementAtOrNull(2) != null &&
                                folder.covers.elementAtOrNull(2) != ''
                            ? Image.file(
                                File(folder.covers[2]!),
                                isAntiAlias: true,
                                opacity: AlwaysStoppedAnimation(0.4),
                              )
                            : viewModel.coverAspectRatio != null
                            ? AspectRatio(
                                aspectRatio: viewModel.coverAspectRatio!,
                                child: SizedBox.expand(),
                              )
                            : SizedBox.expand(),
                      ),
                    ),
                    Transform.rotate(
                      angle: (pi / 180) * 4,
                      child: Card(
                        clipBehavior: .antiAlias,
                        color: ColorScheme.of(context).surfaceContainerHigh,
                        margin: .all(0),
                        child:
                            folder.covers.elementAtOrNull(1) != null &&
                                folder.covers.elementAtOrNull(1) != ''
                            ? Image.file(
                                File(folder.covers[1]!),
                                isAntiAlias: true,
                                opacity: AlwaysStoppedAnimation(0.7),
                              )
                            : viewModel.coverAspectRatio != null
                            ? AspectRatio(
                                aspectRatio: viewModel.coverAspectRatio!,
                                child: SizedBox.expand(),
                              )
                            : SizedBox.expand(),
                      ),
                    ),
                    Card(
                      clipBehavior: .antiAlias,
                      color: ColorScheme.of(context).surfaceContainerHighest,
                      margin: .all(0),
                      child: viewModel.getFolderCover1.running || folder.parsing
                          ? SizedBox.expand(
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : folder.covers.elementAtOrNull(0) != null &&
                                folder.covers.elementAtOrNull(0) != ''
                          ? Image.file(
                              File(folder.covers[0]!),
                              isAntiAlias: true,
                            )
                          : SizedBox.expand(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: .only(
            top: viewModel.libraryDisplaySpacing == .comfortable
                ? 8
                : viewModel.libraryDisplaySpacing == .normal
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
                    text: folder.title,
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
