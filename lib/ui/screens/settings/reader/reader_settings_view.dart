import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../data/models/settings.dart';
import '../widgets/card_input.dart';
import '../widgets/card_list.dart';
import '../widgets/card_tile.dart';
import '../widgets/card_dropdown.dart';
import 'reader_settings_view_model.dart';

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
                CardTile(
                  subtitle: Text('Toggle app animations'),
                  title: Text('Animations'),
                  trailing: AnimationsSwitch(viewModel: viewModel),
                ),
                CardTile(
                  subtitle: ReadingDirectionDropdown(viewModel: viewModel),
                  title: Text('Reading direction'),
                ),
                CardTile(
                  subtitle: ReadingModeDropdown(viewModel: viewModel),
                  title: Text('Reading mode'),
                ),
                CardTile(
                  subtitle: ZoomLevelInput(viewModel: viewModel),
                  title: Text('Zoom level'),
                ),
                CardTile(
                  subtitle: Text(
                    'Disabling double tap zoom allows for instant single tap feedback',
                  ),
                  title: Text('Double tap zoom'),
                  trailing: DoubleTapZoomSwitch(viewModel: viewModel),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AnimationsSwitch extends StatefulWidget {
  const AnimationsSwitch({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  State<AnimationsSwitch> createState() => _AnimationsSwitchState();
}

class _AnimationsSwitchState extends State<AnimationsSwitch> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.loadAnimations.running) {
          return SizedBox.shrink();
        }
        return Switch(
          value: widget.viewModel.animations,
          onChanged: (value) {
            setState(() {
              widget.viewModel.toggleAnimations.execute();
            });
          },
        );
      },
    );
  }
}

class ReadingDirectionDropdown extends StatefulWidget {
  const ReadingDirectionDropdown({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  State<ReadingDirectionDropdown> createState() =>
      _ReadingDirectionDropdownState();
}

class _ReadingDirectionDropdownState extends State<ReadingDirectionDropdown> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return CardDropdown(
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
          initialSelection: (widget.viewModel.loadReadingDirection.running)
              ? null
              : widget.viewModel.readingDirection,
          onSelected: (value) {
            if (value != null) {
              widget.viewModel.setReadingDirection.execute(value);
            }
          },
        );
      },
    );
  }
}

class ReadingModeDropdown extends StatefulWidget {
  const ReadingModeDropdown({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  State<ReadingModeDropdown> createState() => _ReadingModeDropdownState();
}

class _ReadingModeDropdownState extends State<ReadingModeDropdown> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return CardDropdown(
          dropdownMenuEntries: [
            DropdownMenuEntry(value: ReadingMode.single, label: 'Single page'),
            DropdownMenuEntry(value: ReadingMode.double, label: 'Double page'),
            DropdownMenuEntry(
              value: ReadingMode.continuous,
              label: 'Continuous',
            ),
          ],
          initialSelection: (widget.viewModel.loadReadingMode.running)
              ? null
              : widget.viewModel.readingMode,
          onSelected: (value) {
            if (value != null) {
              widget.viewModel.setReadingMode.execute(value);
            }
          },
        );
      },
    );
  }
}

class ZoomLevelInput extends StatefulWidget {
  const ZoomLevelInput({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  State<ZoomLevelInput> createState() => _ZoomLevelInputState();
}

class _ZoomLevelInputState extends State<ZoomLevelInput> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.loadZoom.running) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: TextFormField(),
          );
        }
        return CardInput(
          initialValue: widget.viewModel.zoom.toString(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
          ],
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onFieldSubmitted: (value) {
            widget.viewModel.setZoom.execute(double.parse(value));
          },
        );
      },
    );
  }
}

class DoubleTapZoomSwitch extends StatefulWidget {
  const DoubleTapZoomSwitch({super.key, required this.viewModel});

  final ReaderSettingsViewModel viewModel;

  @override
  State<DoubleTapZoomSwitch> createState() => _DoubleTapZoomSwitchState();
}

class _DoubleTapZoomSwitchState extends State<DoubleTapZoomSwitch> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.loadDoubleTapZoom.running) {
          return SizedBox(width: 48);
        }
        return Switch(
          value: widget.viewModel.doubleTapZoom,
          onChanged: (value) {
            setState(() {
              widget.viewModel.toggleDoubleTapZoom.execute();
            });
          },
        );
      },
    );
  }
}
