import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../library_view_model.dart';

class AddLibrary extends StatelessWidget {
  final BuildContext context;
  final LibraryViewModel viewModel;

  const AddLibrary({required this.context, super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        spacing: 0,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.folder_outlined),
            label: Align(alignment: .centerStart, child: Text('Local folder')),
            onPressed: () async {
              await viewModel.addLocalFolder.execute();
              if (context.mounted) {
                context.pop();
              }
            },
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.dns_rounded),
            label: Align(alignment: .centerStart, child: Text('OPDS server')),
            onPressed: () async {
              if (context.mounted) {
                context.pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
