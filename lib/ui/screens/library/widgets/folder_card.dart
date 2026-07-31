import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/folder_item.dart';
import '../../../../routing/routes.dart';

class FolderCard extends StatelessWidget {
  const FolderCard({super.key, required this.folder});

  final FolderItem folder;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: Center(child: Text(folder.name)),
        onTap: () {
          context.pushNamed(
            RouteNames.folder,
            pathParameters: {'folderId': folder.id},
          );
        },
      ),
    );
  }
}
