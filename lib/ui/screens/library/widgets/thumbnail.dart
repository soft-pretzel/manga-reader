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
  void initState() {
    super.initState();
    if (widget.item.thumbnail == null) {
      widget.viewModel.getThumbnail.execute(widget.item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.getThumbnail,
      builder: (context, child) {
        if (widget.viewModel.getThumbnail.running) {
          return Center(child: CircularProgressIndicator());
        }

        if (widget.viewModel.getThumbnail.error ||
            widget.item.thumbnail == null) {
          return Center(
            child: Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
          );
        }

        return Image.file(File(widget.item.thumbnail!));
      },
    );
  }
}
