import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../library_view_model.dart';
import '../../../../data/models/folder.dart';
import '../../../../routing/routes.dart';
import 'folder_menu.dart';

class FolderListTile extends StatelessWidget {
  FolderListTile({
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
    return SizedBox(
      height: switch (viewModel.libraryDisplaySpacing) {
        .comfortable => 120,
        .normal => 104,
        .compact => 88,
      },
      child: Container(
        color: viewModel.selected[index]
            ? ColorScheme.of(context).surfaceBright.withAlpha(128)
            : null,
        child: GestureDetector(
          behavior: .translucent,
          onLongPressStart: (details) {
            if (!viewModel.isSelectionMode) _handleLongPress(details);
          },
          child: InkWell(
            onTap: () {
              context.pushNamed(
                RouteNames.folder,
                pathParameters: {'folderId': folder.id},
              );
            },
            child: FolderMenu(
              folder: folder,
              index: index,
              menuController: _menuController,
              viewModel: viewModel,
              child: Padding(
                padding: switch (viewModel.libraryDisplaySpacing) {
                  .comfortable => .symmetric(horizontal: 24, vertical: 12),
                  .normal => .symmetric(horizontal: 20, vertical: 10),
                  .compact => .symmetric(horizontal: 16, vertical: 8),
                },
                child: Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: folder.covers[0] == null
                          ? Center(child: CircularProgressIndicator())
                          : Center(
                              child: Image.file(
                                File(folder.covers.first!),
                                alignment: .centerLeft,
                              ),
                            ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: .start,
                        mainAxisAlignment: .center,
                        children: [
                          RichText(
                            maxLines: 1,
                            overflow: .ellipsis,
                            text: TextSpan(
                              style: TextTheme.of(context).bodyLarge,
                              text: folder.title,
                            ),
                          ),
                          RichText(
                            maxLines: 1,
                            overflow: .ellipsis,
                            text: TextSpan(
                              style: TextTheme.of(context).bodyMedium!.apply(
                                color: ColorScheme.of(context).outline,
                              ),
                              text: folder.items.length == 1
                                  ? '${folder.items.length} item'
                                  : '${folder.items.length} items',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: .centerRight,
                        child: Icon(Icons.keyboard_arrow_right_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
