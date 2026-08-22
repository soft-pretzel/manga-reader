import 'package:flutter/material.dart';

import '../../../../data/models/settings.dart';
import 'appearance_settings_view_model.dart';

class AppearanceSettingsView extends StatefulWidget {
  const AppearanceSettingsView({super.key, required this.viewModel});

  final AppearanceSettingsViewModel viewModel;

  @override
  State<AppearanceSettingsView> createState() => _AppearanceSettingsViewState();
}

class _AppearanceSettingsViewState extends State<AppearanceSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Appearance')),
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.viewModel.load.execute,
            child: ListenableBuilder(
              listenable: widget.viewModel.load,
              builder: (context, child) {
                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Card(
                      margin: EdgeInsets.all(0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Theme'),
                            trailing: DropdownMenu(
                              initialSelection: widget.viewModel.theme,
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: ThemeMode.light,
                                  label: 'Light',
                                ),
                                DropdownMenuEntry(
                                  value: ThemeMode.dark,
                                  label: 'Dark',
                                ),
                                DropdownMenuEntry(
                                  value: ThemeMode.system,
                                  label: 'System',
                                ),
                              ],
                              onSelected: (value) {
                                if (value != null) {
                                  widget.viewModel.setTheme.execute(value);
                                }
                              },
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
      ],
    );
  }
}
