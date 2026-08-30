import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../data/models/settings.dart';
import '../../../widgets/card_tile_dropdown.dart';
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
                builder: (context, _) {
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
                              subtitle: Text('Toggle app animations'),
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
                            Divider(height: 0),
                            CardTileDropdown(
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
                                  widget.viewModel.setReadingDirection.execute(
                                    value,
                                  );
                                }
                              },
                              title: 'Reading direction',
                            ),
                            Divider(height: 0),
                            CardTileDropdown(
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
                              title: 'Reading mode',
                            ),
                            Divider(height: 0),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              subtitle: Text(
                                'Used for double tap and long press zoom',
                              ),
                              title: Text('Zoom level'),
                              trailing: SizedBox(
                                height: 36,
                                width: 160,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                  initialValue: widget.viewModel.zoom
                                      .toString(),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}'),
                                    ),
                                  ],
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
                            ),
                            Divider(height: 0),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              subtitle: Text(
                                'Disabling double tap zoom allows for instant single tap actions',
                              ),
                              title: Text('Double tap zoom'),
                              trailing: Switch(
                                value: widget.viewModel.doubleTapZoom,
                                onChanged: (value) {
                                  setState(() {
                                    widget.viewModel.toggleDoubleTapZoom
                                        .execute();
                                  });
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
