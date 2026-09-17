import 'package:flutter/material.dart';

import '../appearance_settings_view_model.dart';

class DynamicColorTile extends StatelessWidget {
  const DynamicColorTile({super.key, required this.viewModel});

  final AppearanceSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      subtitle: Text('Use system theme colors'),
      title: Text('Dynamic color'),
      trailing: Switch(
        value: viewModel.dynamicMode,
        onChanged: (value) {
          viewModel.toggleDynamicMode.execute();
        },
      ),
    );
  }
}
