import 'package:flutter/material.dart';

class CardDropdown extends StatelessWidget {
  const CardDropdown({
    super.key,
    required this.dropdownMenuEntries,
    this.initialSelection,
    this.onSelected,
  });

  final List<DropdownMenuEntry> dropdownMenuEntries;
  final dynamic initialSelection;
  final void Function(dynamic)? onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DropdownMenu(
            dropdownMenuEntries: dropdownMenuEntries,
            enableFilter: true,
            initialSelection: initialSelection,
            onSelected: onSelected,
            width: constraints.maxWidth,
          );
        },
      ),
    );
  }
}
