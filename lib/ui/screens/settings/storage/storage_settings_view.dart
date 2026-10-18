import 'package:flutter/material.dart';

import '../widgets/card_list.dart';
import 'storage_settings_view_model.dart';
import 'widgets/cache_size_tile.dart';
import 'widgets/database_size_tile.dart';

class StorageSettingsView extends StatelessWidget {
  const StorageSettingsView({super.key, required this.viewModel});

  final StorageSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text("Local Storage")),
        Expanded(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              if (viewModel.load.running) {
                return SizedBox.shrink();
              }
              return CardList(
                children: [
                  CacheSizeTile(viewModel: viewModel),
                  DatabaseSizeTile(viewModel: viewModel),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
