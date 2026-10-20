import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'folder_menu.dart';
import '../library_view_model.dart';
import '../../../../data/models/folder.dart';
import '../../../../routing/routes.dart';

class FolderTile extends StatefulWidget {
  const FolderTile({super.key, required this.folder, required this.viewModel});

  final Folder folder;
  final LibraryViewModel viewModel;

  @override
  State<FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile> {
  final _menuController = MenuController();

  void _handleLongPress(LongPressStartDetails details) {
    _menuController.open(position: details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(0),
            child: GestureDetector(
              onTap: () {
                context.pushNamed(
                  RouteNames.folder,
                  pathParameters: {'folderId': widget.folder.id},
                );
              },
              onLongPressStart: _handleLongPress,
              child: FolderMenu(
                menuController: _menuController,
                viewModel: widget.viewModel,
                child: Center(child: Icon(Icons.folder_outlined)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: Wrap(
            children: [
              RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  text: widget.folder.name,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // No need to redraw the shape unless it changes.
  }
}
