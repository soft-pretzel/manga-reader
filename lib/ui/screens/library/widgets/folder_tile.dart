import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'folder_item_count.dart';
import 'folder_menu.dart';
import 'thumbnail.dart';
import '../library_view_model.dart';
import '../../../../data/models/folder.dart';
import '../../../../routing/routes.dart';

class FolderTile extends StatefulWidget {
  const FolderTile({super.key, required this.series, required this.viewModel});

  final Folder series;
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
      children: [
        Flexible(
          flex: 4,
          child: Card(
            margin: EdgeInsets.all(0),
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              onTap: () {
                context.pushNamed(
                  RouteNames.series,
                  pathParameters: {'seriesId': widget.series.id},
                );
              },
              onLongPressStart: _handleLongPress,
              child: FolderMenu(
                menuController: _menuController,
                viewModel: widget.viewModel,
                child: Stack(
                  children: [
                    Thumbnail(item: widget.series, viewModel: widget.viewModel),
                    FolderItemCount(
                      series: widget.series,
                      viewModel: widget.viewModel,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Align(
            alignment: AlignmentGeometry.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Wrap(
                children: [
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      text: widget.series.name,
                    ),
                  ),
                ],
              ),
            ),
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
