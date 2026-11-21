import 'package:material_ui/material_ui.dart';

import '../appearance_settings_view_model.dart';

class EreaderModeTile extends StatelessWidget {
  const EreaderModeTile({super.key, required this.viewModel});

  final AppearanceSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      subtitle: Text('Disable animations across the app'),
      title: Text('E-reader mode'),
      trailing: Switch(
        value: viewModel.ereaderMode,
        onChanged: (_) {
          viewModel.toggleEreaderMode.execute();
        },
      ),
    );
  }
}
