import 'package:flutter/material.dart';

import 'settings_view_model.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Settings')),
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.viewModel.load.execute,
            child: ListenableBuilder(
              listenable: widget.viewModel.load,
              builder: (context, child) {
                if (widget.viewModel.load.running) {
                  return Center(child: CircularProgressIndicator());
                }

                if (widget.viewModel.load.error) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error loading Settings'),
                      FilledButton(
                        onPressed: widget.viewModel.load.execute,
                        child: Text('Try Again'),
                      ),
                    ],
                  );
                }

                return child!;
              },
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsGeometry.fromLTRB(
                                8,
                                0,
                                0,
                                4,
                              ),
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
                                    onPressed:
                                        widget.viewModel.setFolder.execute,
                                    icon: Icon(Icons.edit),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
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
