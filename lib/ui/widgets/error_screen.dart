import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.function, required this.text});

  final Function function;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
          SizedBox(height: 12),
          Text(text),
          TextButton(onPressed: () => function(), child: Text('Try Again')),
        ],
      ),
    );
  }
}
