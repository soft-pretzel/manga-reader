import 'package:flutter/material.dart';

import '../reader_view_model.dart';

class MenuButtons extends StatefulWidget {
  const MenuButtons({super.key, required this.viewModel});

  final ReaderViewModel viewModel;

  @override
  State<MenuButtons> createState() => _MenuButtonsState();
}

class _MenuButtonsState extends State<MenuButtons> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  widget.viewModel.toggleAnimations.execute();
                },
                icon: Icon(
                  (widget.viewModel.animations)
                      ? Icons.blur_on
                      : Icons.blur_off,
                ),
                color: Theme.of(context).colorScheme.primary,
              ),
              IconButton(
                onPressed: () {
                  switch (widget.viewModel.readingMode) {
                    case .single:
                      widget.viewModel.setReadingMode.execute(.double);
                    case .double:
                      widget.viewModel.setReadingMode.execute(.continuous);
                    case .continuous:
                      widget.viewModel.setReadingMode.execute(.single);
                  }
                },
                icon: Icon(() {
                  switch (widget.viewModel.readingMode) {
                    case .single:
                      return Icons.looks_one;
                    case .double:
                      return Icons.looks_two;
                    case .continuous:
                      return Icons.all_inclusive;
                  }
                }()),
                color: Theme.of(context).colorScheme.primary,
              ),
              IconButton(
                onPressed: () {
                  switch (widget.viewModel.readingDirection) {
                    case .leftToRight:
                      widget.viewModel.setReadingDirection.execute(
                        .rightToLeft,
                      );
                    case .rightToLeft:
                      widget.viewModel.setReadingDirection.execute(.vertical);
                    case .vertical:
                      widget.viewModel.setReadingDirection.execute(
                        .leftToRight,
                      );
                  }
                },
                icon: Icon(() {
                  switch (widget.viewModel.readingDirection) {
                    case .leftToRight:
                      return Icons.keyboard_double_arrow_right;
                    case .rightToLeft:
                      return Icons.keyboard_double_arrow_left;
                    case .vertical:
                      return Icons.keyboard_double_arrow_down;
                  }
                }()),
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}
