import 'package:flutter/material.dart';

import '../appearance_settings_view_model.dart';

class ThemeModeTile extends StatelessWidget {
  const ThemeModeTile({super.key, required this.viewModel});

  final AppearanceSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text('Theme mode'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                return DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: ThemeMode.light, label: 'Light'),
                    DropdownMenuEntry(value: ThemeMode.dark, label: 'Dark'),
                    DropdownMenuEntry(value: ThemeMode.system, label: 'System'),
                  ],
                  initialSelection: (viewModel.loadThemeMode.running)
                      ? null
                      : viewModel.themeMode,
                  onSelected: (value) {
                    if (value != null) {
                      viewModel.setThemeMode.execute(value);
                    }
                  },
                  width: constraints.maxWidth,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
