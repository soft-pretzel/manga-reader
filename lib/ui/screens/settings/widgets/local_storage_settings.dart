import 'package:flutter/material.dart';

import '../settings_view_model.dart';

class LocalStorageSettings extends StatefulWidget {
  const LocalStorageSettings({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<LocalStorageSettings> createState() => _LocalStorageSettingsState();
}

class _LocalStorageSettingsState extends State<LocalStorageSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(8, 0, 0, 4),
          child: Text('Local Folder'),
        ),
        if (widget.viewModel.folder == null)
          FilledButton(
            onPressed: widget.viewModel.setFolder.execute,
            child: Text('Add Folder'),
          )
        else
          Card(
            margin: EdgeInsets.all(0),
            child: ListTile(
              leading: Icon(Icons.folder),
              title: Text(widget.viewModel.folder!),
              trailing: IconButton(
                onPressed: widget.viewModel.setFolder.execute,
                icon: Icon(Icons.edit),
              ),
            ),
          ),
      ],
    );
  }
}
