import 'package:flutter/material.dart';

import '../reader_settings_view_model.dart';

class AnimationsTile extends StatelessWidget {
  const AnimationsTile({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      subtitle: Text('Toggle reader animations'),
      title: Text('Animations'),
      trailing: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.loadAnimations.running) {
            return SizedBox.shrink();
          }
          return Switch(
            value: viewModel.animations,
            onChanged: (_) {
              viewModel.toggleAnimations.execute();
            },
          );
        },
      ),
    );
  }
}
