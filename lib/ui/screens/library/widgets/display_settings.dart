import 'package:flutter/material.dart';

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
                      viewModel.displayMode == .grid,
                      viewModel.displayMode == .list,
                    ],
                    onPressed: (index) {
                      switch (index) {
                        case 0:
                          viewModel.setDisplayMode.execute(.grid);
                        case 1:
                          viewModel.setDisplayMode.execute(.list);
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
                      viewModel.spacing == .comfortable,
                      viewModel.spacing == .normal,
                      viewModel.spacing == .compact,
                    ],
                    onPressed: (index) {
                      switch (index) {
                        case 0:
                          viewModel.setSpacing.execute(.comfortable);
                        case 1:
                          viewModel.setSpacing.execute(.normal);
                        case 2:
                          viewModel.setSpacing.execute(.compact);
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
                      viewModel.filter.contains(ReadingStatus.unread),
                      viewModel.filter.contains(ReadingStatus.inProgress),
                      viewModel.filter.contains(ReadingStatus.finished),
                    ],
                    onPressed: (index) {
                      switch (index) {
                        case 0:
                          viewModel.setFilter.execute(.unread);
                        case 1:
                          viewModel.setFilter.execute(.inProgress);
                        case 2:
                          viewModel.setFilter.execute(.finished);
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
                      viewModel.sort == .alphabetical ||
                          viewModel.sort == .alphabeticalReverse,
                      viewModel.sort == .dateAdded ||
                          viewModel.sort == .dateAddedReverse,
                      viewModel.sort == .lastRead ||
                          viewModel.sort == .lastReadReverse,
                    ],
                    onPressed: (index) {
                      switch (index) {
                        case 0:
                          if (viewModel.sort == .alphabetical) {
                            viewModel.setSort.execute(.alphabeticalReverse);
                          } else {
                            viewModel.setSort.execute(.alphabetical);
                          }
                        case 1:
                          if (viewModel.sort == .dateAdded) {
                            viewModel.setSort.execute(.dateAddedReverse);
                          } else {
                            viewModel.setSort.execute(.dateAdded);
                          }
                        case 2:
                          if (viewModel.sort == .lastRead) {
                            viewModel.setSort.execute(.lastReadReverse);
                          } else {
                            viewModel.setSort.execute(.lastRead);
                          }
                      }
                    },
                    children: [
                      Row(
                        mainAxisAlignment: .center,
                        children: [
                          Text('Alphabetical'),
                          if (viewModel.sort == .alphabetical)
                            Icon(Icons.keyboard_arrow_down_rounded),
                          if (viewModel.sort == .alphabeticalReverse)
                            Icon(Icons.keyboard_arrow_up_rounded),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: .center,
                        children: [
                          Text('Date added'),
                          if (viewModel.sort == .dateAdded)
                            Icon(Icons.keyboard_arrow_down_rounded),
                          if (viewModel.sort == .dateAddedReverse)
                            Icon(Icons.keyboard_arrow_up_rounded),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: .center,
                        children: [
                          Text('Last read'),
                          if (viewModel.sort == .lastRead)
                            Icon(Icons.keyboard_arrow_down_rounded),
                          if (viewModel.sort == .lastReadReverse)
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
