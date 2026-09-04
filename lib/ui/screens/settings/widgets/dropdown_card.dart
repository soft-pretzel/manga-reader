import 'package:flutter/material.dart';

class DropdownCard extends StatelessWidget {
  const DropdownCard({
    super.key,
    required this.dropdownMenuEntries,
    this.initialSelection,
    this.onSelected,
    this.subtitle,
    required this.title,
  });

  final List<DropdownMenuEntry> dropdownMenuEntries;
  final dynamic initialSelection;
  final Function(dynamic)? onSelected;
  final String? subtitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      subtitle: (subtitle != null) ? Text(subtitle!) : null,
      title: Text(title),
      trailing: DropdownMenu(
        dropdownMenuEntries: dropdownMenuEntries,
        enableFilter: true,
        initialSelection: initialSelection,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          constraints: BoxConstraints.tight(Size.fromHeight(36)),
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
        ),
        onSelected: (onSelected != null) ? onSelected : null,
        selectedTrailingIcon: Transform.translate(
          offset: Offset(0, -5),
          child: Icon(Icons.arrow_drop_up),
        ),
        trailingIcon: Transform.translate(
          offset: Offset(0, -5),
          child: Icon(Icons.arrow_drop_down),
        ),
        width: 160,
      ),
    );
  }
}
