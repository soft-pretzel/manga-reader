import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/settings.dart';
import '../library_view_model.dart';

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
              if (viewModel.isSelectionMode)
                IconButton(
                  onPressed: () => viewModel.disableSelectionMode.execute(),
                  icon: Icon(Icons.close),
                ),
              MenuAnchor(
                controller: _menuController,
                menuChildren: [
                  if (viewModel.isSelectionMode)
                    MenuItemButton(
                      onPressed: () {
                        viewModel.markSelectedAsFinished.execute();
                        viewModel.disableSelectionMode.execute();
                      },
                      trailingIcon: Icon(Icons.task_alt_rounded),
                      child: Text('Mark as finished'),
                    ),
                  if (viewModel.isSelectionMode)
                    MenuItemButton(
                      onPressed: () {
                        viewModel.markSelectedAsUnread.execute();
                        viewModel.disableSelectionMode.execute();
                      },
                      trailingIcon: Icon(Icons.replay_rounded),
                      child: Text('Mark as unread'),
                    ),
                  if (!viewModel.isSelectionMode)
                    MenuItemButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: Text('Add new library'),
                            children: [
                              SimpleDialogOption(
                                onPressed: () {
                                  context.pop();
                                  viewModel.addLocalFolder.execute();
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.folder_outlined),
                                    SizedBox(width: 8),
                                    Text('Local folder'),
                                  ],
                                ),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  context.pop();
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.computer_rounded),
                                    SizedBox(width: 8),
                                    Text('OPDS server'),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      trailingIcon: Icon(Icons.my_library_add_outlined),
                      child: Text('Add new library'),
                    ),
                  if (viewModel.selected.any((item) => item == false))
                    MenuItemButton(
                      onPressed: () {
                        viewModel.selectAll.execute();
                      },
                      trailingIcon: Icon(Icons.select_all),
                      child: Text('Select all'),
                    ),
                  if (!viewModel.isSelectionMode)
                    MenuItemButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Column(
                              crossAxisAlignment: .stretch,
                              mainAxisSize: .min,
                              spacing: 16,
                              children: [
                                DropdownMenu(
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry(
                                      value: LibraryDisplayMode.grid,
                                      label: 'Grid',
                                    ),
                                    DropdownMenuEntry(
                                      value: LibraryDisplayMode.list,
                                      label: 'List',
                                    ),
                                  ],
                                  expandedInsets: .all(0),
                                  initialSelection:
                                      viewModel.libraryDisplayMode,
                                  label: Text('Mode'),
                                  onSelected: (value) {
                                    if (value != null) {
                                      viewModel.setLibraryDisplayMode.execute(
                                        value,
                                      );
                                    }
                                  },
                                ),
                                DropdownMenu(
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry(
                                      value: LibraryDisplaySpacing.comfortable,
                                      label: 'Comfortable',
                                    ),
                                    DropdownMenuEntry(
                                      value: LibraryDisplaySpacing.normal,
                                      label: 'Default',
                                    ),
                                    DropdownMenuEntry(
                                      value: LibraryDisplaySpacing.compact,
                                      label: 'Compact',
                                    ),
                                  ],
                                  expandedInsets: .all(0),
                                  initialSelection:
                                      viewModel.libraryDisplaySpacing,
                                  label: Text('Spacing'),
                                  onSelected: (value) {
                                    if (value != null) {
                                      viewModel.setLibraryDisplaySpacing
                                          .execute(value);
                                    }
                                  },
                                ),
                              ],
                            ),
                            title: Text('Display settings'),
                          );
                        },
                      ),
                      trailingIcon: Icon(Icons.display_settings_rounded),
                      child: Text('Display'),
                    ),
                  if (!viewModel.isSelectionMode)
                    SubmenuButton(
                      menuChildren: [
                        MenuItemButton(
                          onPressed: () {
                            if (viewModel.librarySort == .alphabetical) {
                              viewModel.setLibrarySort.execute(
                                .alphabeticalReverse,
                              );
                            } else {
                              viewModel.setLibrarySort.execute(.alphabetical);
                            }
                          },
                          trailingIcon: viewModel.librarySort == .alphabetical
                              ? Icon(Icons.arrow_drop_down)
                              : viewModel.librarySort == .alphabeticalReverse
                              ? Icon(Icons.arrow_drop_up)
                              : null,
                          child: Text('Alphabetical'),
                        ),
                        MenuItemButton(
                          onPressed: () {
                            if (viewModel.librarySort == .dateAdded) {
                              viewModel.setLibrarySort.execute(
                                .dateAddedReverse,
                              );
                            } else {
                              viewModel.setLibrarySort.execute(.dateAdded);
                            }
                          },
                          trailingIcon: viewModel.librarySort == .dateAdded
                              ? Icon(Icons.arrow_drop_down)
                              : viewModel.librarySort == .dateAddedReverse
                              ? Icon(Icons.arrow_drop_up)
                              : null,
                          child: Text('Date added'),
                        ),
                        MenuItemButton(
                          onPressed: () {
                            if (viewModel.librarySort == .fileSize) {
                              viewModel.setLibrarySort.execute(
                                .fileSizeReverse,
                              );
                            } else {
                              viewModel.setLibrarySort.execute(.fileSize);
                            }
                          },
                          trailingIcon: viewModel.librarySort == .fileSize
                              ? Icon(Icons.arrow_drop_down)
                              : viewModel.librarySort == .fileSizeReverse
                              ? Icon(Icons.arrow_drop_up)
                              : null,
                          child: Text('File size'),
                        ),
                      ],
                      submenuIcon: WidgetStatePropertyAll(Icon(Icons.sort)),
                      child: Text('Sort'),
                    ),
                ],
                child: IconButton(
                  onPressed: _menuController.open,
                  icon: Icon(Icons.more_vert),
                ),
              ),
            ],
            actionsPadding: .all(0),
            title: Text(viewModel.title),
          );
        }
      },
    );
  }
}
