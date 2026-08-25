import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'menu_buttons.dart';
import 'reader_slider.dart';
import '../reader_view_model.dart';

class ReaderMenu<T> extends PopupRoute<T> {
  ReaderMenu({
    required this.orientation,
    required this.pageController,
    required this.viewModel,
  });

  final Orientation orientation;
  final PageController pageController;
  final ReaderViewModel viewModel;

  bool _stillReading = true;
  final _transitionDuration = Duration(milliseconds: 200);

  @override
  Color? get barrierColor => Colors.black.withAlpha(50);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Reader Menu';

  @override
  void didComplete(T? result) {
    if (_stillReading) {
      Future.delayed(
        (viewModel.animations) ? _transitionDuration : Duration.zero,
        () {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        },
      );
    }
    super.didComplete(result);
  }

  @override
  Duration get transitionDuration =>
      (viewModel.animations) ? _transitionDuration : Duration.zero;

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
          color: Theme.of(context).colorScheme.surface.withAlpha(224),
          child: SafeArea(
            bottom: false,
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
                Text(viewModel.book.name),
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
          color: Theme.of(context).colorScheme.surface.withAlpha(224),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                MenuButtons(viewModel: viewModel),
                ReaderSlider(
                  orientation: orientation,
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
