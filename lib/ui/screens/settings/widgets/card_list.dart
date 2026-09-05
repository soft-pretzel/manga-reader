import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  const CardList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Card(
          clipBehavior: Clip.hardEdge,
          margin: (children.length == 1)
              ? EdgeInsets.all(0)
              : (index == 0)
              ? EdgeInsets.only(bottom: 1)
              : (index == children.length - 1)
              ? EdgeInsets.only(top: 1)
              : EdgeInsets.symmetric(vertical: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular((index == 0) ? 20 : 4),
              topRight: Radius.circular((index == 0) ? 20 : 4),
              bottomLeft: Radius.circular(
                (index == children.length - 1) ? 20 : 4,
              ),
              bottomRight: Radius.circular(
                (index == children.length - 1) ? 20 : 4,
              ),
            ),
          ),
          child: children[index],
        );
      },
      itemCount: children.length,
    );
  }
}
