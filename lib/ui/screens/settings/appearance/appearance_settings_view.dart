import 'dart:io';

import 'package:flutter/material.dart';

import 'appearance_settings_view_model.dart';
import '../widgets/card_list.dart';
import 'widgets/dynamic_color_tile.dart';
import 'widgets/oled_dark_mode_tile.dart';
import 'widgets/theme_color_tile.dart';
import 'widgets/theme_mode_tile.dart';

class AppearanceSettingsView extends StatelessWidget {
  const AppearanceSettingsView({super.key, required this.viewModel});

  final AppearanceSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Appearance')),
        Expanded(
          child: RefreshIndicator(
            onRefresh: viewModel.refresh.execute,
            child: CardList(
              children: [
                ThemeModeTile(viewModel: viewModel),
                if (!Platform.isIOS) DynamicColorTile(viewModel: viewModel),
                ThemeColorTile(viewModel: viewModel),
                OledDarkModeTile(viewModel: viewModel),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
