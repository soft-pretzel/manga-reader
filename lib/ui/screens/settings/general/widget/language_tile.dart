import 'package:flutter/material.dart';

import '../general_settings_view_model.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({super.key, required this.viewModel});

  final GeneralSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text('Language'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                return DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 'English', label: 'English'),
                  ],
                  initialSelection: 'English',
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
