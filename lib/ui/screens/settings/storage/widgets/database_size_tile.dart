import 'package:flutter/material.dart';

import '../storage_settings_view_model.dart';

class DatabaseSizeTile extends StatelessWidget {
  const DatabaseSizeTile({super.key, required this.viewModel});

  final StorageSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text('Database size'),
      trailing: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.loadDatabaseSize.running) {
            return SizedBox.shrink();
          }
          return Text(
            viewModel.dbSize,
            style: Theme.of(context).textTheme.bodyMedium,
          );
        },
      ),
    );
  }
}
