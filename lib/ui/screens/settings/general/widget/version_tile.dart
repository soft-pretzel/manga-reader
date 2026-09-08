import 'package:flutter/material.dart';

import '../general_settings_view_model.dart';

class VersionTile extends StatelessWidget {
  const VersionTile({super.key, required this.viewModel});

  final GeneralSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text('Version'),
      trailing: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.loadVersion.running) {
            return SizedBox.shrink();
          }
          return Text(
            viewModel.version,
            style: Theme.of(context).textTheme.bodyMedium,
          );
        },
      ),
    );
  }
}
