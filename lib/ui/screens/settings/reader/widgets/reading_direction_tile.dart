import 'package:flutter/material.dart';

import '../../../../../data/models/settings.dart';
import '../reader_settings_view_model.dart';

class ReadingDirectionTile extends StatelessWidget {
  const ReadingDirectionTile({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text('Reading direction'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                return DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(
                      value: ReadingDirection.leftToRight,
                      label: 'Left to right',
                    ),
                    DropdownMenuEntry(
                      value: ReadingDirection.rightToLeft,
                      label: 'Right to left',
                    ),
                    DropdownMenuEntry(
                      value: ReadingDirection.vertical,
                      label: 'Vertical',
                    ),
                  ],
                  initialSelection: (viewModel.loadReadingDirection.running)
                      ? null
                      : viewModel.readingDirection,
                  onSelected: (value) {
                    if (value != null) {
                      viewModel.setReadingDirection.execute(value);
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
