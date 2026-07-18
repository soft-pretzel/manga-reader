import 'dart:io';

import 'package:flutter/material.dart';

import 'widgets/reader_menu.dart';

class ReaderView extends StatefulWidget {
  const ReaderView({super.key, required this.pages});

  final List<String> pages;

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(ReaderMenu());
      },
      child: PageView(
        controller: _pageController,
        reverse: true,
        children: [for (final page in widget.pages) Image.file(File(page))],
      ),
    );
  }
}
