import 'package:flutter/material.dart';

import 'folder_view_model.dart';

class FolderView extends StatelessWidget {
  const FolderView({super.key, required this.viewModel});

  final FolderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        if (viewModel.load.running) {
          return SizedBox.shrink();
        }
        return Column(
          children: [
            AppBar(title: Text(viewModel.title)),
            Expanded(child: GridView.count(crossAxisCount: 3)),
          ],
        );
      },
    );
  }
}
