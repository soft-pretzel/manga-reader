import 'package:flutter/material.dart';

import '../settings_view_model.dart';

class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<AppearanceSettings> createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends State<AppearanceSettings> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ],
    );
  }
}
