import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../reader_view_model.dart';

class ReaderMenu<T> extends PopupRoute<T> {
  ReaderMenu({
    required this.currentPage,
    required this.pageController,
    required this.viewModel,
  });

  int currentPage;
  final PageController pageController;
  final ReaderViewModel viewModel;

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
            child: ReaderSlider(
              currentPage: currentPage,
              pageController: pageController,
              viewModel: viewModel,
            ),
          ),
        ],
      ),
    );
  }
}

class ReaderSlider extends StatefulWidget {
  ReaderSlider({
    super.key,
    required this.currentPage,
    required this.pageController,
    required this.viewModel,
  });

  int currentPage;
  final PageController pageController;
  final ReaderViewModel viewModel;

  @override
  State<ReaderSlider> createState() => _ReaderSliderState();
}

class _ReaderSliderState extends State<ReaderSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            '${widget.currentPage + 1} / ${widget.viewModel.pages.length + 1}',
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Slider(
            min: 0,
            max: widget.viewModel.pages.length.toDouble(),
            value: widget.currentPage.toDouble(),
            onChanged: (double newPage) {
              widget.pageController.animateToPage(
                newPage.toInt(),
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 500),
              );
              setState(() {
                widget.currentPage = newPage.toInt();
              });
            },
          ),
        ),
      ],
    );
  }
}
