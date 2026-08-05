import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/series_model.dart';
import '../../../../routing/routes.dart';

class FolderCard extends StatelessWidget {
  const FolderCard({super.key, required this.folder});

  final SeriesModel folder;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: () {
          // if (folder.thumbnail != null) {
          //   return Image.file(File(folder.thumbnail!));
          // } else {
          return Center(child: Text(folder.name));
          // }
        }(),
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
