import 'package:flutter/material.dart';

import '../../../../../data/models/settings.dart';
import 'reader_settings_view_model.dart';

class ReaderSettingsView extends StatefulWidget {
  const ReaderSettingsView({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  State<ReaderSettingsView> createState() => _ReaderSettingsViewState();
}

class _ReaderSettingsViewState extends State<ReaderSettingsView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}
