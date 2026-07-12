import 'package:flutter/material.dart';

import 'widgets/reader_menu.dart';

class ReaderView extends StatefulWidget {
  const ReaderView({super.key});

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
        children: [
          for (int i = 0; i <= 4; i++)
            Image(image: AssetImage('assets/images/test_page_00$i.jpg')),
        ],
      ),
    );
  }
}
