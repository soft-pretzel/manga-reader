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
      subtitle: Text(viewModel.dbSize),
    );
  }
}
