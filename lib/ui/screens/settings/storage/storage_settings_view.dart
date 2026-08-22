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
          child: RefreshIndicator(
            onRefresh: widget.viewModel.load.execute,
            child: ListenableBuilder(
              listenable: widget.viewModel.load,
              builder: (context, child) {
                if (widget.viewModel.load.running) {
                  return Center(child: CircularProgressIndicator());
                }
                return child!;
              },
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, child) {
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Card(
                        margin: EdgeInsets.all(0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Local folder'),
                              subtitle: Text(
                                widget.viewModel.folder ?? 'No folder selected',
                              ),
                              trailing: IconButton(
                                onPressed: widget.viewModel.setFolder.execute,
                                icon: Icon(Icons.edit),
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
          ),
        ),
      ],
    );
  }
}
