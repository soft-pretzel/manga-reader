import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../data/models/library.dart';
import '../library_view_model.dart';

class Thumbnail extends StatefulWidget {
  const Thumbnail({super.key, required this.item, required this.viewModel});

  final Library item;
  final LibraryViewModel viewModel;

  @override
  State<Thumbnail> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.loadThumbnails,
      builder: (context, _) {
        if (widget.item.thumbnail == null ||
            (widget.item.thumbnail != null &&
                File(widget.item.thumbnail!).existsSync() == false)) {
          return Center(child: CircularProgressIndicator());
        }
        return Image.file(File(widget.item.thumbnail!));
      },
    );
  }
}
