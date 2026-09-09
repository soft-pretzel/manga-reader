import 'package:flutter/material.dart';

import '../appearance_settings_view_model.dart';

class OledDarkModeTile extends StatelessWidget {
  const OledDarkModeTile({super.key, required this.viewModel});

  final AppearanceSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      enabled: viewModel.themeMode != .light,
      subtitle: Text('Use a true black background'),
      title: Text('OLED dark mode'),
      trailing: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.loadOledDarkMode.running) {
            return SizedBox.shrink();
          }
          return Switch(
            value: viewModel.oledDarkMode,
            onChanged: (viewModel.themeMode != .light)
                ? (_) {
                    viewModel.toggleOledDarkMode.execute();
                  }
                : null,
          );
        },
      ),
    );
  }
}
