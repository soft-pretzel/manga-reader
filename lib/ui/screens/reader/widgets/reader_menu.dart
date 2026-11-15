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
        SizedBox(
          height: 100,
          child: CarouselView.weightedBuilder(
            controller: viewModel.carouselController,
            itemBuilder: (context, index) {
              if (index == 0) {
                final page = viewModel.pages[index];
                if (page == null) {
                  return Center(child: CircularProgressIndicator());
                }
                return GestureDetector(
                  onTap: () {
                    viewModel.goToFirstPage.execute();
                  },
                  child: Image.memory(page),
                );
              } else {
                index = index * 2;
                final leftPage = viewModel.pages[index];
                final rightPage = viewModel.pages[index - 1];
                if (leftPage == null || rightPage == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return GestureDetector(
                    onTap: () {
                      if (viewModel.ereaderMode) {
                        viewModel.pageController.jumpToPage(index);
                      } else {
                        viewModel.pageController.animateToPage(
                          index,
                          duration: viewModel.duration,
                          curve: viewModel.curve,
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        Image.memory(leftPage),
                        Image.memory(rightPage),
                      ],
                    ),
                  );
                }
              }
            },
            itemCount: viewModel.book.pageCount! % 2 == 0
                ? ((viewModel.book.pageCount! - 2) / 2).toInt() + 2
                : ((viewModel.book.pageCount! - 1) / 2).toInt() + 1,
            flexWeights: [1, 1, 1],
            reverse: viewModel.readingDirection == .rightToLeft,
          ),
        ),
        Card(
          margin: .all(0),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Text('${viewModel.currentPage} / ${viewModel.book.pageCount}'),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (viewModel.readingDirection == .rightToLeft) {
                          viewModel.goToLastPage.execute();
                        } else {
                          viewModel.goToFirstPage.execute();
                        }
                      },
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
                          value: viewModel.currentPage.toDouble(),
                          onChanged: (value) {
                            viewModel.setCurrentPage.execute(value.toInt());
                          },
                          onChangeEnd: (value) {
                            if (viewModel.ereaderMode) {
                              viewModel.pageController.jumpToPage(
                                (value - 1).toInt(),
                              );
                            } else {
                              viewModel.pageController.animateToPage(
                                (value - 1).toInt(),
                                duration: viewModel.duration,
                                curve: viewModel.curve,
                              );
                            }
                            viewModel.updateBook.execute();
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.undo_rounded),
                    ),
                    IconButton(
                      onPressed: () {
                        if (viewModel.readingDirection == .rightToLeft) {
                          viewModel.goToFirstPage.execute();
                        } else {
                          viewModel.goToLastPage.execute();
                        }
                      },
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
