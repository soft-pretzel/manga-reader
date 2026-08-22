import 'package:flutter/material.dart';

import '../../../../data/models/settings.dart';
import 'general_settings_view_model.dart';

class GeneralSettingsView extends StatefulWidget {
  const GeneralSettingsView({super.key, required this.viewModel});

  final GeneralSettingsViewModel viewModel;

  @override
  State<GeneralSettingsView> createState() => _GeneralSettingsViewState();
}

class _GeneralSettingsViewState extends State<GeneralSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('General')),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Card(
                margin: EdgeInsets.all(0),
                child: Column(
                  children: [
                    ListTile(title: Text('Animations')),
                    Divider(),
                    ListTile(
                      title: Text('Reading direction'),
                      subtitle: DropdownMenu(
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: ReadingDirection.leftToRight,
                            label: 'Left to right',
                          ),
                          DropdownMenuEntry(
                            value: ReadingDirection.rightToLeft,
                            label: 'Right to left',
                          ),
                          DropdownMenuEntry(
                            value: ReadingDirection.vertical,
                            label: 'Vertical',
                          ),
                        ],
                        onSelected: (value) {
                          if (value != null) {
                            widget.viewModel.setReadingDirection.execute(value);
                          }
                        },
                      ),
                    ),
                    Divider(),
                    ListTile(title: Text('Reading mode')),
                    Divider(),
                    ListTile(title: Text('Zoom level')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
