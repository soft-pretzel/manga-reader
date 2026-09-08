import 'package:flutter/material.dart';

import '../widgets/card_list.dart';
import 'reader_settings_view_model.dart';
import 'widgets/animations_tile.dart';
import 'widgets/double_tap_zoom_tile.dart';
import 'widgets/reading_direction_tile.dart';
import 'widgets/reading_mode_tile.dart';
import 'widgets/zoom_level_tile.dart';

class ReaderSettingsView extends StatelessWidget {
  const ReaderSettingsView({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Reader')),
        Expanded(
          child: RefreshIndicator(
            onRefresh: viewModel.refresh.execute,
            child: CardList(
              children: [
                AnimationsTile(viewModel: viewModel),
                ReadingDirectionTile(viewModel: viewModel),
                ReadingModeTile(viewModel: viewModel),
                DoubleTapZoomTile(viewModel: viewModel),
                ZoomLevelTile(viewModel: viewModel),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
