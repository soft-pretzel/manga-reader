import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'menu_buttons.dart';
import 'reader_slider.dart';
import '../reader_view_model.dart';

class ReaderMenu<T> extends PopupRoute<T> {
  ReaderMenu({required this.pageController, required this.viewModel});

  final PageController pageController;
  final ReaderViewModel viewModel;

  bool _stillReading = true;

  @override
  Color? get barrierColor => Colors.black.withAlpha(50);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Reader Menu';

  @override
  void didComplete(T? result) {
    if (_stillReading) {
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
          margin: EdgeInsets.all(0),
          color: Theme.of(context).colorScheme.surface.withAlpha(240),
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    _stillReading = false;
                    context
                      ..pop()
                      ..pop();
                  },
                ),
                Text(viewModel.book!.name),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.all(0),
          color: Theme.of(context).colorScheme.surface.withAlpha(240),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                MenuButtons(viewModel: viewModel),
                ReaderSlider(
                  pageController: pageController,
                  viewModel: viewModel,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
