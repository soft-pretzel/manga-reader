import 'package:flutter/material.dart';

import 'appearance_settings_view_model.dart';
import '../widgets/card_dropdown.dart';
import '../widgets/card_list.dart';
import '../widgets/card_tile.dart';

class AppearanceSettingsView extends StatelessWidget {
  const AppearanceSettingsView({super.key, required this.viewModel});

  final AppearanceSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Appearance')),
        Expanded(
          child: RefreshIndicator(
            onRefresh: viewModel.refresh.execute,
            child: CardList(
              children: [
                CardTile(
                  title: Text('Theme mode'),
                  subtitle: ThemeModeDropdown(viewModel: viewModel),
                ),
                CardTile(
                  title: Text('Theme color'),
                  subtitle: ThemeColorSelector(viewModel: viewModel),
                ),
                CardTile(
                  subtitle: Text('Use a true black background'),
                  title: Text('OLED dark mode'),
                  trailing: OledDarkModeSwitch(viewModel: viewModel),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ThemeModeDropdown extends StatefulWidget {
  const ThemeModeDropdown({super.key, required this.viewModel});

  final AppearanceSettingsViewModel viewModel;

  @override
  State<ThemeModeDropdown> createState() => _ThemeModeDropdownState();
}

class _ThemeModeDropdownState extends State<ThemeModeDropdown> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return CardDropdown(
          dropdownMenuEntries: [
            DropdownMenuEntry(value: ThemeMode.light, label: 'Light'),
            DropdownMenuEntry(value: ThemeMode.dark, label: 'Dark'),
            DropdownMenuEntry(value: ThemeMode.system, label: 'System'),
          ],
          initialSelection: (widget.viewModel.loadThemeMode.running)
              ? null
              : widget.viewModel.themeMode,
          onSelected: (value) {
            if (value != null) {
              widget.viewModel.setThemeMode.execute(value);
            }
          },
        );
      },
    );
  }
}

class ThemeColorSelector extends StatefulWidget {
  const ThemeColorSelector({super.key, required this.viewModel});

  final AppearanceSettingsViewModel viewModel;

  @override
  State<ThemeColorSelector> createState() => _ThemeColorSelectorState();
}

class _ThemeColorSelectorState extends State<ThemeColorSelector> {
  final List<Color> _colors = [
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
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: 36,
                width: constraints.maxWidth,
                child: (widget.viewModel.loadThemeColor.running)
                    ? SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (final color in _colors)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: InkWell(
                                onTap: () => widget.viewModel.setThemeColor
                                    .execute(color),
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                      width:
                                          widget.viewModel.themeColor == color
                                          ? 3
                                          : 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              );
            },
          ),
        );
      },
    );
  }
}

class OledDarkModeSwitch extends StatefulWidget {
  const OledDarkModeSwitch({super.key, required this.viewModel});

  final AppearanceSettingsViewModel viewModel;

  @override
  State<OledDarkModeSwitch> createState() => _OledDarkModeSwitchState();
}

class _OledDarkModeSwitchState extends State<OledDarkModeSwitch> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.loadOledDarkMode.running) {
          return SizedBox.shrink();
        }
        return Switch(
          value: widget.viewModel.oledDarkMode,
          onChanged: (value) {
            setState(() {
              widget.viewModel.toggleOledDarkMode.execute();
            });
          },
        );
      },
    );
  }
}
