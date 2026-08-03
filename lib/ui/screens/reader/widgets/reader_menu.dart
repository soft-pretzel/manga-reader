import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'reader_slider.dart';
import '../reader_view_model.dart';

class ReaderMenu<T> extends PopupRoute<T> {
  ReaderMenu({required this.pageController, required this.viewModel});

  final PageController pageController;
  final ReaderViewModel viewModel;

  bool stillReading = true;

  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Reader Menu';

  @override
  void didComplete(T? result) {
    if (stillReading) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
    super.didComplete(result);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    stillReading = false;
                    context
                      ..pop()
                      ..pop();
                  },
                ),
                Text(viewModel.book!.name),
                Spacer(),
                IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ReaderSlider(
              pageController: pageController,
              viewModel: viewModel,
            ),
          ),
        ),
      ],
    );
  }
}
