import 'package:flutter/material.dart';

import '../settings_view_model.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          margin: EdgeInsets.all(0),
          child: Column(
            children: [
              ListTile(title: Text('Version: ')),
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
