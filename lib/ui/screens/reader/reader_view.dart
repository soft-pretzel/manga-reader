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
  late int currentPage;
  late final PageController pageController;

  Future<void> _initController() async {
    await widget.viewModel.getCurrentPage.execute();
    currentPage = widget.viewModel.currentPage;
    pageController = PageController(initialPage: currentPage);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initController();
    });
  }

  @override
  void dispose() {
    widget.viewModel.updateBook.execute(currentPage);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.load,
      builder: (context, child) {
        if (widget.viewModel.load.running) {
          return Center(child: CircularProgressIndicator());
        }

        if (widget.viewModel.load.error) {
          return Center(
            child: Column(
              children: [
                Text('Error opening book'),
                FilledButton(
                  onPressed: widget.viewModel.load.execute,
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
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                ReaderMenu(
                  currentPage: currentPage,
                  pageController: pageController,
                  viewModel: widget.viewModel,
                ),
              );
            },
            child: PageView(
              controller: pageController,
              onPageChanged: (int newPage) => currentPage = newPage,
              reverse: true,
              children: [
                for (final page in widget.viewModel.pages)
                  Image.file(File(page)),
              ],
            ),
          );
        },
      ),
    );
  }
}
