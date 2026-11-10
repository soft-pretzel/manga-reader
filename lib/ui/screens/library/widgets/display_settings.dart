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
                      viewModel.libraryDisplaySpacing == .comfortable,
                      viewModel.libraryDisplaySpacing == .normal,
                      viewModel.libraryDisplaySpacing == .compact,
                    ],
                    onPressed: (index) {
                      switch (index) {
                        case 0:
                          viewModel.setLibraryDisplaySpacing.execute(
                            .comfortable,
                          );
                        case 1:
                          viewModel.setLibraryDisplaySpacing.execute(.normal);
                        case 2:
                          viewModel.setLibraryDisplaySpacing.execute(.compact);
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
                      viewModel.librarySort == .alphabetical ||
                          viewModel.librarySort == .alphabeticalReverse,
                      viewModel.librarySort == .dateAdded ||
                          viewModel.librarySort == .dateAddedReverse,
                      viewModel.librarySort == .lastRead ||
                          viewModel.librarySort == .lastReadReverse,
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
                        case 2:
                          if (viewModel.librarySort == .lastRead) {
                            viewModel.setLibrarySort.execute(.lastReadReverse);
                          } else {
                            viewModel.setLibrarySort.execute(.lastRead);
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
                      Row(
                        mainAxisAlignment: .center,
                        children: [
                          Text('Last read'),
                          if (viewModel.librarySort == .lastRead)
                            Icon(Icons.keyboard_arrow_down_rounded),
                          if (viewModel.librarySort == .lastReadReverse)
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
