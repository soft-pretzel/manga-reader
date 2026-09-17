import 'package:flutter/material.dart';

import '../reader_settings_view_model.dart';

class DoubleTapZoomTile extends StatelessWidget {
  const DoubleTapZoomTile({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      subtitle: Text(
        'Disabling double tap zoom allows for instant single tap feedback',
      ),
      title: Text('Double tap zoom'),
      trailing: Switch(
        value: viewModel.doubleTapZoom,
        onChanged: (_) {
          viewModel.toggleDoubleTapZoom.execute();
        },
      ),
    );
  }
}
