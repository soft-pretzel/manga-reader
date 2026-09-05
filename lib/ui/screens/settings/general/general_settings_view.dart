import 'package:flutter/material.dart';

import '../widgets/card_list.dart';
import '../widgets/card_tile.dart';
import '../widgets/card_dropdown.dart';
import 'general_settings_view_model.dart';

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
                CardTile(
                  title: Text('Version'),
                  trailing: LoadVersion(viewModel: viewModel),
                ),
                CardTile(
                  title: Text('Language'),
                  subtitle: CardDropdown(
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: 'English', label: 'English'),
                    ],
                    initialSelection: 'English',
                  ),
                ),
                CardTile(
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

class LoadVersion extends StatefulWidget {
  const LoadVersion({super.key, required this.viewModel});

  final GeneralSettingsViewModel viewModel;

  @override
  State<LoadVersion> createState() => _LoadVersionState();
}

class _LoadVersionState extends State<LoadVersion> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.loadVersion.running) {
          return SizedBox.shrink();
        }
        if (widget.viewModel.loadVersion.error) {
          return IconButton(
            onPressed: () => widget.viewModel.loadVersion.execute(),
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return Text(
          widget.viewModel.version,
          style: Theme.of(context).textTheme.bodyMedium,
        );
      },
    );
  }
}
