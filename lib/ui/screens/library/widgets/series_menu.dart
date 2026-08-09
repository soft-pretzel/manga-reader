import 'package:flutter/material.dart';

import '../library_view_model.dart';

class SeriesMenu extends StatefulWidget {
  const SeriesMenu({
    super.key,
    required this.menuController,
    required this.viewModel,
    required this.child,
  });

  final MenuController menuController;
  final LibraryViewModel viewModel;
  final Widget child;

  @override
  State<SeriesMenu> createState() => _SeriesMenuState();
}

class _SeriesMenuState extends State<SeriesMenu> {
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
