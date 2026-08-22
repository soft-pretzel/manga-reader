import 'package:flutter/material.dart';

import '../../../../data/models/settings.dart';
import 'reader_settings_view_model.dart';

class ReaderSettingsView extends StatefulWidget {
  const ReaderSettingsView({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  State<ReaderSettingsView> createState() => _ReaderSettingsViewState();
}

class _ReaderSettingsViewState extends State<ReaderSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Reader')),
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.viewModel.load.execute,
            child: ListenableBuilder(
              listenable: widget.viewModel.load,
              builder: (context, child) {
                if (widget.viewModel.load.running) {
                  return Center(child: CircularProgressIndicator());
                }
                return child!;
              },
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, child) {
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Card(
                        margin: EdgeInsets.all(0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Animations'),
                              trailing: Switch(
                                value: widget.viewModel.animations,
                                onChanged: (value) {
                                  setState(() {
                                    widget.viewModel.toggleAnimations.execute();
                                  });
                                },
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Reading direction'),
                              trailing: DropdownMenu(
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(
                                    value: ReadingDirection.leftToRight,
                                    label: 'Left to right',
                                  ),
                                  DropdownMenuEntry(
                                    value: ReadingDirection.rightToLeft,
                                    label: 'Right to left',
                                  ),
                                  DropdownMenuEntry(
                                    value: ReadingDirection.vertical,
                                    label: 'Vertical',
                                  ),
                                ],
                                initialSelection:
                                    widget.viewModel.readingDirection,
                                onSelected: (value) {
                                  if (value != null) {
                                    widget.viewModel.setReadingDirection
                                        .execute(value);
                                  }
                                },
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Reading mode'),
                              trailing: DropdownMenu(
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(
                                    value: ReadingMode.single,
                                    label: 'Single page',
                                  ),
                                  DropdownMenuEntry(
                                    value: ReadingMode.double,
                                    label: 'Double page',
                                  ),
                                  DropdownMenuEntry(
                                    value: ReadingMode.continuous,
                                    label: 'Continuous',
                                  ),
                                ],
                                initialSelection: widget.viewModel.readingMode,
                                onSelected: (value) {
                                  if (value != null) {
                                    widget.viewModel.setReadingMode.execute(
                                      value,
                                    );
                                  }
                                },
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Zoom level'),
                              subtitle: TextFormField(
                                decoration: InputDecoration(),
                                initialValue: widget.viewModel.zoom.toString(),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                onFieldSubmitted: (value) {
                                  widget.viewModel.setZoom.execute(
                                    double.parse(value),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
