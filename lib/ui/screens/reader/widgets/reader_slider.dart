import 'package:flutter/material.dart';

import '../reader_view_model.dart';

class ReaderSlider extends StatefulWidget {
  const ReaderSlider({
    super.key,
    required this.orientation,
    required this.pageController,
    required this.viewModel,
  });

  final Orientation orientation;
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
                '${widget.viewModel.book.currentPage} / ${widget.viewModel.pages.length}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      int newPage = 1;
                      if (widget.viewModel.readingDirection == .rightToLeft) {
                        newPage = widget.viewModel.pages.length;
                      }
                      widget.pageController.animateToPage(
                        newPage - 1,
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 500),
                      );
                      widget.viewModel.updateBook.execute(newPage);
                      setState(() {
                        _pageHistory.add(widget.viewModel.book.currentPage);
                      });
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
                        min: 1,
                        max: widget.viewModel.pages.length.toDouble(),
                        value: widget.viewModel.book.currentPage.toDouble(),
                        onChanged: (double newPage) {
                          if (widget.orientation == .landscape) {
                            newPage = newPage / 2;
                          }
                          widget.pageController.animateToPage(
                            newPage.toInt() - 1,
                            curve: Curves.easeInOut,
                            duration: Duration(milliseconds: 500),
                          );
                          _previousPage ??= widget.viewModel.book.currentPage;
                          widget.viewModel.updateBook.execute(newPage.toInt());
                        },
                        onChangeEnd: (double newPage) {
                          setState(() {
                            _pageHistory.add(_previousPage);
                          });
                          _previousPage = null;
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
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 500),
                        );
                        widget.viewModel.updateBook.execute(newPage);
                        setState(() {
                          _pageHistory.removeLast();
                        });
                      }
                    },
                    icon: Icon(Icons.undo),
                    color: (_pageHistory.isEmpty)
                        ? Theme.of(context).colorScheme.surfaceBright
                        : Theme.of(context).colorScheme.primary,
                  ),
                  IconButton(
                    onPressed: () {
                      int newPage = widget.viewModel.pages.length;
                      if (widget.viewModel.readingDirection == .rightToLeft) {
                        newPage = 1;
                      }
                      widget.pageController.animateToPage(
                        newPage - 1,
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 500),
                      );
                      widget.viewModel.updateBook.execute(newPage);
                      setState(() {
                        _pageHistory.add(widget.viewModel.book.currentPage);
                      });
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
