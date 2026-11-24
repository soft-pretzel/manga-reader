import 'package:material_ui/material_ui.dart';

import '../../../../data/models/book.dart';
import '../library_view_model.dart';

class DisplaySettings extends StatelessWidget {
  final LibraryViewModel viewModel;

  const DisplaySettings({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Padding(
          padding: .fromLTRB(16, 0, 16, 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: .stretch,
                mainAxisSize: .min,
                children: [
                  Text('Display mode', style: TextTheme.of(context).labelLarge),
                  SizedBox(height: 8),
                  ToggleButtons(
                    borderRadius: .all(.circular(8)),
                    constraints: BoxConstraints.expand(
                      width: (constraints.maxWidth / 2) - 2,
                    ),
                    isSelected: [
                      viewModel.libraryDisplayMode == .grid,
                      viewModel.libraryDisplayMode == .list,
                    ],
                    onPressed: (index) {
                      switch (index) {
                        case 0:
                          viewModel.setLibraryDisplayMode.execute(.grid);
                        case 1:
                          viewModel.setLibraryDisplayMode.execute(.list);
                      }
                    },
                    children: [Text('Grid'), Text('List')],
                  ),
                  SizedBox(height: 16),
                  Text('Spacing', style: TextTheme.of(context).labelLarge),
                  SizedBox(height: 8),
                  ToggleButtons(
                    borderRadius: .all(.circular(8)),
                    constraints: BoxConstraints.expand(
                      width: (constraints.maxWidth / 3) - 2,
                    ),
                    isSelected: [
                      viewModel.librarySpacing == .comfortable,
                      viewModel.librarySpacing == .normal,
                      viewModel.librarySpacing == .compact,
                    ],
                    onPressed: (index) {
                      switch (index) {
                        case 0:
                          viewModel.setLibrarySpacing.execute(.comfortable);
                        case 1:
                          viewModel.setLibrarySpacing.execute(.normal);
                        case 2:
                          viewModel.setLibrarySpacing.execute(.compact);
                      }
                    },
                    children: [
                      Text('Comfortable'),
                      Text('Default'),
                      Text('Compact'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Filter', style: TextTheme.of(context).labelLarge),
                  SizedBox(height: 8),
                  ToggleButtons(
                    borderRadius: .all(.circular(8)),
                    constraints: BoxConstraints.expand(
                      width: (constraints.maxWidth / 3) - 2,
                    ),
                    isSelected: [
                      viewModel.libraryFilter.contains(ReadingStatus.unread),
                      viewModel.libraryFilter.contains(
                        ReadingStatus.inProgress,
                      ),
                      viewModel.libraryFilter.contains(ReadingStatus.finished),
                    ],
                    onPressed: (index) {
                      switch (index) {
                        case 0:
                          viewModel.setLibraryFilter.execute(.unread);
                        case 1:
                          viewModel.setLibraryFilter.execute(.inProgress);
                        case 2:
                          viewModel.setLibraryFilter.execute(.finished);
                      }
                    },
                    children: [
                      Text('Unread'),
                      Text('In progress'),
                      Text('Finished'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Sort', style: TextTheme.of(context).labelLarge),
                  SizedBox(height: 8),
                  ToggleButtons(
                    borderRadius: .all(.circular(8)),
                    constraints: BoxConstraints.expand(
                      width: (constraints.maxWidth / 3) - 2,
                    ),
                    isSelected: [
                      viewModel.librarySort == .alphabetical ||
                          viewModel.librarySort == .alphabeticalReverse,
                      viewModel.librarySort == .dateAdded ||
                          viewModel.librarySort == .dateAddedReverse,
                    ],
                    onPressed: (index) {
                      switch (index) {
                        case 0:
                          if (viewModel.librarySort == .alphabetical) {
                            viewModel.setLibrarySort.execute(
                              .alphabeticalReverse,
                            );
                          } else {
                            viewModel.setLibrarySort.execute(.alphabetical);
                          }
                        case 1:
                          if (viewModel.librarySort == .dateAdded) {
                            viewModel.setLibrarySort.execute(.dateAddedReverse);
                          } else {
                            viewModel.setLibrarySort.execute(.dateAdded);
                          }
                      }
                    },
                    children: [
                      Row(
                        mainAxisAlignment: .center,
                        children: [
                          Text('Alphabetical'),
                          if (viewModel.librarySort == .alphabetical)
                            Icon(Icons.keyboard_arrow_down_rounded),
                          if (viewModel.librarySort == .alphabeticalReverse)
                            Icon(Icons.keyboard_arrow_up_rounded),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: .center,
                        children: [
                          Text('Date added'),
                          if (viewModel.librarySort == .dateAdded)
                            Icon(Icons.keyboard_arrow_down_rounded),
                          if (viewModel.librarySort == .dateAddedReverse)
                            Icon(Icons.keyboard_arrow_up_rounded),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
