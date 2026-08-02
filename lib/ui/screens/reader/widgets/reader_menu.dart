import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../reader_view_model.dart';

class ReaderMenu<T> extends PopupRoute<T> {
  ReaderMenu({required this.viewModel});

  final ReaderViewModel viewModel;

  double value = 5;

  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Reader Menu';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  context
                    ..pop()
                    ..pop();
                },
              ),
            ],
          ),
          Card(
            child: Slider(
              min: 0,
              max: 50,
              value: value,
              onChanged: (double newValue) {
                setState(() {
                  value = newValue;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
