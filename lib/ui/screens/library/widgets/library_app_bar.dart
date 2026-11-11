import 'package:flutter/material.dart';

import '../../../../data/models/book.dart';
import '../library_view_model.dart';
import 'add_library.dart';
import 'display_settings.dart';

class LibraryAppBar extends StatelessWidget {
  LibraryAppBar({super.key, required this.viewModel});

  final LibraryViewModel viewModel;
  final _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        if (viewModel.load.running) {
          return SizedBox.shrink();
        } else {
          return AppBar(
            actions: [
              if (viewModel.isSelectionMode) ...[
                Text(viewModel.selectedCount.toString()),
                IconButton(
                  onPressed: () => viewModel.disableSelectionMode.execute(),
                  icon: Icon(Icons.close),
                ),
              ],
              IconButton(
                icon: Icon(Icons.tune_rounded),
                onPressed: () => showModalBottomSheet(
                  backgroundColor: ColorScheme.of(context).surfaceDim,
                  builder: (context) {
                    return DisplaySettings(viewModel: viewModel);
                  },
                  context: context,
                  showDragHandle: true,
                ),
              ),
              MenuAnchor(
                controller: _menuController,
                menuChildren: [
                  if (viewModel.isSelectionMode)
                    MenuItemButton(
                      onPressed: () async {
                        for (final (index, selected)
                            in viewModel.selected.indexed) {
                          if (selected) {
                            await viewModel.markAsFinished.execute(
                              viewModel.library.items[index] as Book,
                            );
                          }
                        }
                        viewModel.disableSelectionMode.execute();
                      },
                      trailingIcon: Icon(Icons.task_alt_rounded),
                      child: Text('Mark as finished'),
                    ),
                  if (viewModel.isSelectionMode)
                    MenuItemButton(
                      onPressed: () async {
                        for (final (index, selected)
                            in viewModel.selected.indexed) {
                          if (selected) {
                            await viewModel.markAsUnread.execute(
                              viewModel.library.items[index] as Book,
                            );
                          }
                        }
                        viewModel.disableSelectionMode.execute();
                      },
                      trailingIcon: Icon(Icons.replay_rounded),
                      child: Text('Mark as unread'),
                    ),
                  if (!viewModel.isSelectionMode &&
                      viewModel.library.title == 'Library')
                    MenuItemButton(
                      onPressed: () async {
                        await showModalBottomSheet(
                          backgroundColor: ColorScheme.of(context).surfaceDim,
                          builder: (context) {
                            return AddLibrary(
                              context: context,
                              viewModel: viewModel,
                            );
                          },
                          context: context,
                          showDragHandle: true,
                        );
                        if (context.mounted && viewModel.snackBar != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () => ScaffoldMessenger.of(
                                  context,
                                ).hideCurrentSnackBar(),
                              ),
                              content: Text(viewModel.snackBar!),
                              persist: false,
                            ),
                          );
                          viewModel.clearSnackBar.execute();
                        }
                      },
                      trailingIcon: Icon(Icons.my_library_add_outlined),
                      child: Text('Add new library'),
                    ),
                  if (viewModel.library.items.isNotEmpty &&
                      viewModel.selected.any((item) => item == false))
                    MenuItemButton(
                      onPressed: () {
                        viewModel.selectAll.execute();
                      },
                      trailingIcon: Icon(Icons.select_all),
                      child: Text('Select all'),
                    ),
                ],
                child: IconButton(
                  onPressed: _menuController.open,
                  icon: Icon(Icons.more_vert),
                ),
              ),
            ],
            actionsPadding: .all(0),
            title: Text(viewModel.library.title),
          );
        }
      },
    );
  }
}
