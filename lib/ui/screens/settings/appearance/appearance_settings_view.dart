import 'package:flutter/material.dart';

import '../../../widgets/card_tile_dropdown.dart';
import '../../../widgets/error_screen.dart';
import 'appearance_settings_view_model.dart';

class AppearanceSettingsView extends StatefulWidget {
  const AppearanceSettingsView({super.key, required this.viewModel});

  final AppearanceSettingsViewModel viewModel;

  @override
  State<AppearanceSettingsView> createState() => _AppearanceSettingsViewState();
}

class _AppearanceSettingsViewState extends State<AppearanceSettingsView> {
  final List<Color> _swatches = [
    Color(0xff6750a4),
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.green,
    Colors.teal,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Appearance')),
        Expanded(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, child) {
              if (widget.viewModel.load.running) {
                return SizedBox.shrink();
              }
              if (widget.viewModel.load.error) {
                return ErrorScreen(
                  function: widget.viewModel.load.execute,
                  text: 'Error loading settings',
                );
              }
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
                          initialSelection: widget.viewModel.themeMode,
                          onSelected: (value) {
                            if (value != null) {
                              widget.viewModel.setThemeMode.execute(value);
                            }
                          },
                          title: 'Theme mode',
                        ),
                        Divider(height: 0),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text('Theme color'),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SizedBox(
                              height: 36,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (final c in _swatches)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      child: InkWell(
                                        onTap: () => widget
                                            .viewModel
                                            .setThemeColor
                                            .execute(c),
                                        borderRadius: BorderRadius.circular(4),
                                        child: Container(
                                          width: 36,
                                          decoration: BoxDecoration(
                                            color: c,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            border: Border.all(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onPrimaryContainer,
                                              width:
                                                  widget.viewModel.themeColor ==
                                                      c
                                                  ? 3
                                                  : 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(height: 0),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          enabled: (widget.viewModel.themeMode == .light)
                              ? false
                              : true,
                          subtitle: Text('Use a true black background'),
                          title: Text('OLED dark mode'),
                          trailing: Switch(
                            value: widget.viewModel.oledDarkMode,
                            onChanged: (widget.viewModel.themeMode == .light)
                                ? null
                                : (value) {
                                    setState(() {
                                      widget.viewModel.toggleOledDarkMode
                                          .execute();
                                    });
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
      ],
    );
  }
}
