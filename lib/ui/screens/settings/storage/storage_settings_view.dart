import 'package:flutter/material.dart';

import 'storage_settings_view_model.dart';

class StorageSettingsView extends StatefulWidget {
  const StorageSettingsView({super.key, required this.viewModel});

  final StorageSettingsViewModel viewModel;

  @override
  State<StorageSettingsView> createState() => _StorageSettingsViewState();
}

class _StorageSettingsViewState extends State<StorageSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text("Local Storage")),
        Expanded(
          child: ListenableBuilder(
            listenable: widget.viewModel.load,
            builder: (context, child) {
              if (widget.viewModel.load.running) {
                return SizedBox.shrink();
              }
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Card(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text('Local folder'),
                          subtitle: Text(
                            widget.viewModel.folder ?? 'No folder selected',
                          ),
                          trailing: IconButton(
                            onPressed: widget.viewModel.setFolder.execute,
                            icon: Icon(Icons.edit),
                          ),
                        ),
                        Divider(height: 0),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text('Cache size'),
                          trailing: Text(
                            widget.viewModel.cacheSize,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Divider(height: 0),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text('Database size'),
                          trailing: Text(
                            widget.viewModel.dbSize,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
