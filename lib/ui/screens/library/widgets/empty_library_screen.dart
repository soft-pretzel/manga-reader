import 'package:flutter/material.dart';

class EmptyLibraryScreen extends StatelessWidget {
  const EmptyLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 64,
                ),
                SizedBox(height: 12),
                Text('Add a library to get started'),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text('Tap the'),
                    Icon(
                      Icons.more_vert,
                      color: ColorScheme.of(context).primary,
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'icon and select ',
                        children: [
                          TextSpan(
                            text: 'Add new library',
                            style: TextStyle(fontWeight: .bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
