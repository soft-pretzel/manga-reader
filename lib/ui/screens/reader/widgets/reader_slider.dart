import 'package:flutter/material.dart';

import '../reader_view_model.dart';

class ReaderSlider extends StatefulWidget {
  const ReaderSlider({
    super.key,
    required this.pageController,
    required this.viewModel,
  });

  final PageController pageController;
  final ReaderViewModel viewModel;

  @override
  State<ReaderSlider> createState() => _ReaderSliderState();
}

class _ReaderSliderState extends State<ReaderSlider> {
  int? _previousPage;
  late final _pageHistory = [];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${widget.viewModel.currentPage + 1} / ${widget.viewModel.pages.length}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      int newPage = 0;
                      if (widget.viewModel.readingDirection == .rightToLeft) {
                        newPage = widget.viewModel.pages.length - 1;
                      }
                      widget.pageController.animateToPage(
                        newPage,
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 500),
                      );
                      setState(() {
                        _pageHistory.add(widget.viewModel.currentPage);
                        widget.viewModel.currentPage = newPage;
                      });
                      widget.viewModel.updateBook.execute(newPage);
                    },
                    icon: Icon(Icons.first_page),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Directionality(
                    textDirection:
                        (widget.viewModel.readingDirection == .rightToLeft)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Expanded(
                      child: Slider(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        min: 0,
                        max: widget.viewModel.pages.length.toDouble() - 1,
                        value: widget.viewModel.currentPage.toDouble(),
                        onChanged: (double newPage) {
                          _previousPage ??= widget.viewModel.currentPage;
                          setState(() {
                            widget.viewModel.currentPage = newPage.toInt();
                          });
                        },
                        onChangeEnd: (double newPage) {
                          widget.pageController.animateToPage(
                            newPage.toInt(),
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 500),
                          );
                          setState(() {
                            _pageHistory.add(_previousPage);
                          });
                          _previousPage = null;
                          widget.viewModel.updateBook.execute(newPage.toInt());
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_pageHistory.isNotEmpty) {
                        final newPage = _pageHistory.last;
                        widget.pageController.animateToPage(
                          newPage,
                          curve: Curves.easeIn,
                          duration: Duration(milliseconds: 500),
                        );
                        setState(() {
                          _pageHistory.removeLast();
                          widget.viewModel.currentPage = newPage;
                        });
                        widget.viewModel.updateBook.execute(newPage);
                      }
                    },
                    icon: Icon(Icons.undo),
                    color: (_pageHistory.isEmpty)
                        ? Theme.of(context).colorScheme.surfaceBright
                        : Theme.of(context).colorScheme.primary,
                  ),
                  IconButton(
                    onPressed: () {
                      int newPage = widget.viewModel.pages.length - 1;
                      if (widget.viewModel.readingDirection == .rightToLeft) {
                        newPage = 0;
                      }
                      widget.pageController.animateToPage(
                        newPage,
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 500),
                      );
                      setState(() {
                        _pageHistory.add(widget.viewModel.currentPage);
                        widget.viewModel.currentPage = newPage;
                      });
                      widget.viewModel.updateBook.execute(newPage);
                    },
                    icon: Icon(Icons.last_page),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
