import 'package:flutter/material.dart';

import '../library_view_model.dart';

class LibraryAppBar extends StatelessWidget {
  LibraryAppBar({super.key, required this.viewModel});

  final LibraryViewModel viewModel;
  final _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.load.running) {
            return SizedBox.shrink();
          }
          return Text(viewModel.title);
        },
      ),
      actions: [
        MenuAnchor(
          controller: _menuController,
          menuChildren: [
            SubmenuButton(
              menuChildren: [
                MenuItemButton(
                  onPressed: () => viewModel.addLocalFolder.execute(),
                  trailingIcon: Icon(Icons.folder_outlined),
                  child: Text('Local folder'),
                ),
                MenuItemButton(
                  onPressed: () {},
                  trailingIcon: Icon(Icons.computer_outlined),
                  child: Text('OPDS server'),
                ),
              ],
              submenuIcon: WidgetStatePropertyAll(
                Icon(Icons.library_add_outlined),
              ),
              child: Text('Add new library'),
            ),
            MenuItemButton(
              onPressed: () {},
              trailingIcon: Icon(Icons.select_all),
              child: Text('Select all'),
            ),
            MenuItemButton(
              onPressed: () {},
              trailingIcon: Icon(Icons.sort),
              child: Text('Sort'),
            ),
          ],
          child: IconButton(
            onPressed: _menuController.open,
            icon: Icon(Icons.more_vert, color: ColorScheme.of(context).primary),
          ),
        ),
      ],
    );
  }
}
