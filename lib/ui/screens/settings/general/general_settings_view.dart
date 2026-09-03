import 'package:flutter/material.dart';

import '../../../widgets/card_tile_dropdown.dart';
import 'general_settings_view_model.dart';

class GeneralSettingsView extends StatefulWidget {
  const GeneralSettingsView({super.key, required this.viewModel});

  final GeneralSettingsViewModel viewModel;

  @override
  State<GeneralSettingsView> createState() => _GeneralSettingsViewState();
}

class _GeneralSettingsViewState extends State<GeneralSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('General')),
        Expanded(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, child) {
              if (widget.viewModel.load.running) {
                return SizedBox.shrink();
              }
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Card(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text('Version'),
                          trailing: Text(
                            widget.viewModel.version,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Divider(height: 0),
                        CardTileDropdown(
                          dropdownMenuEntries: [
                            DropdownMenuEntry(
                              value: 'English',
                              label: 'English',
                            ),
                          ],
                          initialSelection: 'English',
                          title: 'Language',
                        ),
                        Divider(height: 0),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text('Source code'),
                          trailing: Icon(Icons.open_in_new),
                          onTap: () {
                            widget.viewModel.openLink.execute(
                              Uri.parse(
                                'https://github.com/soft-pretzel/manga-reader',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
