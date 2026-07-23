import 'dart:io';

import 'package:flutter/material.dart';

import 'reader_view_model.dart';
import 'widgets/reader_menu.dart';

class ReaderView extends StatefulWidget {
  const ReaderView({super.key, required this.viewModel});

  final ReaderViewModel viewModel;

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.openBook.running) {
          return Center(child: CircularProgressIndicator());
        }

        if (widget.viewModel.openBook.error) {
          return Center(child: Text('Error opening book'));
        }

        if (widget.viewModel.openBook.completed) {
          final pages = widget.viewModel.pages;
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(ReaderMenu());
            },
            child: PageView(
              controller: _pageController,
              reverse: true,
              children: [for (final page in pages) Image.file(File(page))],
            ),
          );
        }

        return SizedBox();
      },
    );
  }
}
