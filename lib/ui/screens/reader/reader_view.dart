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
  int _currentPage = 0;
  void _onPageChanged(int page) {
    _currentPage = page;
  }

  @override
  void dispose() {
    widget.viewModel.updateBook.execute(_currentPage);
    PageController().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.loadBook.running) {
          return Center(child: CircularProgressIndicator());
        }

        if (widget.viewModel.loadBook.error) {
          return Center(
            child: Column(
              children: [
                Text('Error opening book'),
                FilledButton(
                  onPressed: widget.viewModel.loadBook.execute,
                  child: Text('Try Again'),
                ),
              ],
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(ReaderMenu());
          },
          child: PageView(
            controller: PageController(
              initialPage: widget.viewModel.currentPage ?? 0,
            ),
            onPageChanged: _onPageChanged,
            reverse: true,
            children: [
              for (final page in widget.viewModel.pages) Image.file(File(page)),
            ],
          ),
        );
      },
    );
  }
}
