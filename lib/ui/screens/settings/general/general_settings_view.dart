import 'package:flutter/material.dart';

import '../widgets/card_list.dart';
import 'general_settings_view_model.dart';
import 'widget/language_tile.dart';
import 'widget/source_tile.dart';
import 'widget/version_tile.dart';

class GeneralSettingsView extends StatelessWidget {
  const GeneralSettingsView({super.key, required this.viewModel});

  final GeneralSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('General')),
        Expanded(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              if (viewModel.load.running) {
                return SizedBox.shrink();
              }
              return CardList(
                children: [
                  VersionTile(viewModel: viewModel),
                  LanguageTile(viewModel: viewModel),
                  SourceTile(viewModel: viewModel),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
