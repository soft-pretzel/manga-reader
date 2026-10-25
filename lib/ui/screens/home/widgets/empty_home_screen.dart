import 'package:flutter/material.dart';

class EmptyHomeScreen extends StatelessWidget {
  const EmptyHomeScreen({super.key});

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 64,
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Start reading from the '),
                    Icon(
                      Icons.menu_book_rounded,
                      color: ColorScheme.of(context).primary,
                    ),
                    Text.rich(
                      TextSpan(
                        text: ' Library',
                        style: TextStyle(fontWeight: .bold),
                        children: [
                          TextSpan(
                            text: ' page',
                            style: TextStyle(fontWeight: .normal),
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
