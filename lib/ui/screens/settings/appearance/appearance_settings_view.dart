import 'package:flutter/material.dart';

import '../../../widgets/card_tile_dropdown.dart';
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
                if (widget.viewModel.load.running) {
                  return Center(child: CircularProgressIndicator());
                }
                return child!;
              },
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  return ListView(
                    clipBehavior: Clip.hardEdge,
                    padding: EdgeInsets.all(16),
                    children: [
                      Card(
                        margin: EdgeInsets.all(0),
                        child: Column(
                          children: [
                            CardTileDropdown(
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
                              initialSelection: widget.viewModel.theme,
                              onSelected: (value) {
                                if (value != null) {
                                  widget.viewModel.setTheme.execute(value);
                                }
                              },
                              title: 'Theme',
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
