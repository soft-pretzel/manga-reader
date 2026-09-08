import 'package:flutter/material.dart';

import '../widgets/card_list.dart';
import 'general_settings_view_model.dart';
import 'widget/language_tile.dart';
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
          child: RefreshIndicator(
            onRefresh: viewModel.refresh.execute,
            child: CardList(
              children: [
                VersionTile(viewModel: viewModel),
                LanguageTile(viewModel: viewModel),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  onTap: () {
                    viewModel.openLink.execute(
                      Uri.parse('https://github.com/soft-pretzel/manga-reader'),
                    );
                  },
                  title: Text('Source code'),
                  trailing: Icon(Icons.open_in_new),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
