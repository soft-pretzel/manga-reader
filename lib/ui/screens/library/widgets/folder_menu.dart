import 'package:flutter/material.dart';

import '../library_view_model.dart';

class FolderMenu extends StatefulWidget {
  const FolderMenu({
    super.key,
    required this.menuController,
    required this.viewModel,
    required this.child,
  });

  final MenuController menuController;
  final LibraryViewModel viewModel;
  final Widget child;

  @override
  State<FolderMenu> createState() => _FolderMenuState();
}

class _FolderMenuState extends State<FolderMenu> {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      animated: true,
      controller: widget.menuController,
      menuChildren: [
        MenuItemButton(onPressed: () {}, child: Text('Update thumbnail')),
        MenuItemButton(onPressed: () {}, child: Text('Details')),
      ],
      child: widget.child,
    );
  }
}
