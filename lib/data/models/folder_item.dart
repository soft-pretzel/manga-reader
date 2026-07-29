import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'library_item.dart';
import '../../routing/routes.dart';

class FolderItem extends LibraryItem {
  FolderItem({
    required super.id,
    required super.name,
    required super.path,
    super.thumbnail,
    super.parentId,
  });

  FolderItem.fromMap(super.map) : super.fromMap();

  @override
  Widget buildCard(BuildContext context) {
    return Card(
      child: InkWell(
        child: Center(child: Text(name)),
        onTap: () {
          context.pushNamed(
            RouteNames.folderContents,
            pathParameters: {'folderId': id},
          );
        },
      ),
    );
  }
}
