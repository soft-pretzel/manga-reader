import 'package:flutter/material.dart';

import '../storage_settings_view_model.dart';

class LocalFolderTile extends StatelessWidget {
  const LocalFolderTile({super.key, required this.viewModel});

  final StorageSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text('Local folder'),
      subtitle: Text(viewModel.folder ?? 'No folder selected'),
      onTap: viewModel.setFolder.execute,
    );
  }
}
