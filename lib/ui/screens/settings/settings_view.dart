import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'settings_view_model.dart';
import '../../../routing/routes.dart';

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
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      Text('Error loading Settings'),
                      TextButton(
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
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Card(
                        margin: EdgeInsets.all(0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.settings_outlined),
                              title: Text('General'),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                context.pushNamed(RouteNames.generalSettings);
                              },
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.folder_outlined),
                              title: Text('Local Storage'),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                context.pushNamed(RouteNames.storageSettings);
                              },
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.palette_outlined),
                              title: Text('Appearance'),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                context.pushNamed(
                                  RouteNames.appearanceSettings,
                                );
                              },
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.menu_book_outlined),
                              title: Text('Reader'),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                context.pushNamed(RouteNames.readerSettings);
                              },
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
