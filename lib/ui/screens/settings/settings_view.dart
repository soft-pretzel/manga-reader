import 'package:flutter/material.dart';

// import 'settings_view_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  // final SettingsViewModel viewModel = SettingsViewModel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Settings'),
      // child: ListenableBuilder(
      //   listenable: viewModel,
      //   builder: (context, _) {
      //     return Switch(
      //       value: viewModel.isDarkMode,
      //       onChanged: (_) {
      //         viewModel.toggle.execute();
      //       },
      //     );
      //   },
      // ),
    );
  }
}
