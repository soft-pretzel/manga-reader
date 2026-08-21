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
    return ListView(
      children: [
        Card(
          margin: EdgeInsets.all(0),
          child: Column(
            children: [
              ListTile(
                title: Text('Theme'),
                subtitle: DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: ThemeMode.light, label: 'Light'),
                    DropdownMenuEntry(value: ThemeMode.dark, label: 'Dark'),
                    DropdownMenuEntry(value: ThemeMode.system, label: 'System'),
                  ],
                  onSelected: (value) {
                    if (value != null) {
                      widget.viewModel.setTheme.execute(value);
                    }
                  },
                ),
              ),
              Divider(),
              ListTile(title: Text('Language:')),
              Divider(),
              ListTile(
                title: Text('Source'),
                trailing: Icon(Icons.open_in_new),
                onTap: () {
                  // Use url_launcher to open github page
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
