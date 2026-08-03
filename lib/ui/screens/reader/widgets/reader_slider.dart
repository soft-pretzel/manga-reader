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
  late int _currentPage;

  Future<void> _getCurrentPage() async {
    await widget.viewModel.getCurrentPage.execute();
    _currentPage = widget.viewModel.currentPage;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPage();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.getCurrentPage,
      builder: (context, child) {
        if (widget.viewModel.getCurrentPage.running) {
          return SizedBox();
        }

        if (widget.viewModel.getCurrentPage.error) {
          return Center(
            child: Column(
              children: [
                Text('Error getting book details'),
                FilledButton(
                  onPressed: widget.viewModel.getCurrentPage.execute,
                  child: Text('Try Again'),
                ),
              ],
            ),
          );
        }

        return child!;
      },
      child: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  '${_currentPage + 1} / ${widget.viewModel.pages.length + 1}',
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Slider(
                  min: 0,
                  max: widget.viewModel.pages.length.toDouble(),
                  value: _currentPage.toDouble(),
                  onChanged: (double newPage) {
                    widget.pageController.animateToPage(
                      newPage.toInt(),
                      curve: Curves.easeIn,
                      duration: Duration(milliseconds: 500),
                    );
                    setState(() {
                      _currentPage = newPage.toInt();
                    });
                    widget.viewModel.updateBook.execute(newPage.toInt());
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
