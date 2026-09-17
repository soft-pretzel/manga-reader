import 'package:flutter/material.dart';

import '../appearance_settings_view_model.dart';

class ThemeColorTile extends StatelessWidget {
  const ThemeColorTile({super.key, required this.viewModel});

  final AppearanceSettingsViewModel viewModel;
  static const List<Color> _colors = [
    Color(0xff6750a4),
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.green,
    Colors.teal,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      enabled: !viewModel.dynamicMode,
      title: Text('Theme color'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: 36,
              width: constraints.maxWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final color in _colors)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: InkWell(
                        onTap: !viewModel.dynamicMode
                            ? () => viewModel.setThemeColor.execute(color)
                            : null,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          width: 36,
                          decoration: BoxDecoration(
                            color: !viewModel.dynamicMode
                                ? color
                                : color.withAlpha(128),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                              width: viewModel.dynamicMode
                                  ? 0
                                  : viewModel.themeColor == color
                                  ? 3
                                  : 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
