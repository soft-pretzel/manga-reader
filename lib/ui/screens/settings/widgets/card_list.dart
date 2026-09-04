import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  const CardList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.hardEdge,
            margin: (index == 0)
                ? EdgeInsets.only(bottom: 2)
                : (index == children.length - 1)
                ? EdgeInsets.only(top: 2)
                : EdgeInsets.symmetric(vertical: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular((index == 0) ? 16 : 4),
                topRight: Radius.circular((index == 0) ? 16 : 4),
                bottomLeft: Radius.circular(
                  (index == children.length - 1) ? 16 : 4,
                ),
                bottomRight: Radius.circular(
                  (index == children.length - 1) ? 16 : 4,
                ),
              ),
            ),
            child: children[index],
          );
        },
        itemCount: children.length,
      ),
    );
  }
}
