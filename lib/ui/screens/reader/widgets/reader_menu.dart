import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../reader_view_model.dart';

class ReaderMenu extends StatelessWidget {
  final ReaderViewModel viewModel;

  const ReaderMenu({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: .all(0),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context..pop(),
                  icon: Icon(Icons.arrow_back),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        Card(
          margin: .all(0),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Text(
                  '${viewModel.book.currentPage} / ${viewModel.book.pageCount}',
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.first_page_rounded),
                    ),
                    Expanded(
                      child: Directionality(
                        textDirection:
                            viewModel.readingDirection == .rightToLeft
                            ? .rtl
                            : .ltr,
                        child: Slider(
                          max: viewModel.book.pageCount!.toDouble(),
                          min: 1,
                          value: viewModel.book.currentPage.toDouble(),
                          onChanged: (value) {
                            viewModel.setCurrentPage.execute(value.toInt());
                            viewModel.pageController.jumpToPage(
                              (value - 1).toInt(),
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.undo_rounded),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.last_page_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
