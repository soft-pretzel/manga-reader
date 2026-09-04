import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key, required this.function, required this.text});

  final Function function;
  final String text;

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
                  Icons.sentiment_dissatisfied,
                  color: Theme.of(context).colorScheme.primary,
                  size: 64,
                ),
                SizedBox(height: 12),
                Text(text),
                TextButton(onPressed: () => function(), child: Text('Reload')),
              ],
            ),
          ),
        );
      },
    );
  }
}
