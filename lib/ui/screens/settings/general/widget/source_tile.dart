import 'package:flutter/material.dart';

import '../general_settings_view_model.dart';

class SourceTile extends StatelessWidget {
  const SourceTile({super.key, required this.viewModel});

  final GeneralSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () {
        viewModel.openLink.execute(
          Uri.parse('https://github.com/soft-pretzel/manga-reader'),
        );
      },
      title: Text('Source code'),
      trailing: Icon(Icons.open_in_new),
    );
  }
}
