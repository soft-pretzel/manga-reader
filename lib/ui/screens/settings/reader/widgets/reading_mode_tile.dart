import 'package:flutter/material.dart';

import '../../../../../data/models/settings.dart';
import '../reader_settings_view_model.dart';

class ReadingModeTile extends StatelessWidget {
  const ReadingModeTile({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text('Reading mode'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return DropdownMenu(
              dropdownMenuEntries: [
                DropdownMenuEntry(
                  value: ReadingMode.single,
                  label: 'Single page',
                ),
                DropdownMenuEntry(
                  value: ReadingMode.double,
                  label: 'Double page',
                ),
                DropdownMenuEntry(
                  value: ReadingMode.continuous,
                  label: 'Continuous',
                ),
              ],
              initialSelection: viewModel.readingMode,
              onSelected: (value) {
                if (value != null) {
                  viewModel.setReadingMode.execute(value);
                }
              },
              width: constraints.maxWidth,
            );
          },
        ),
      ),
    );
  }
}
