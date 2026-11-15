import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'reader_view_model.dart';
import 'widgets/reader_menu.dart';

class ReaderView extends StatefulWidget {
  final ReaderViewModel viewModel;

  const ReaderView({super.key, required this.viewModel});

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView>
    with SingleTickerProviderStateMixin {
  bool _menuVisible = false;
  late Orientation _orientation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _orientation = MediaQuery.of(context).orientation;
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
    widget.viewModel.setReadingStatus.execute();
    widget.viewModel.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        if (widget.viewModel.load.running) {
          return Center(child: CircularProgressIndicator());
        }
        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation != _orientation) {
              _orientation = orientation;
              int index = widget.viewModel.book.currentPage - 1;
              if (orientation == .landscape) {
                index = (index / 2).round();
              }
              widget.viewModel.pageController.jumpToPage(index);
            }
            return Stack(
              children: [
                PageView.builder(
                  controller: widget.viewModel.pageController,
                  itemBuilder: (context, index) {
                    if (orientation == .portrait || index == 0) {
                      final page = widget.viewModel.pages[index];
                      if (page == null) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Image.memory(page);
                    } else {
                      index = index * 2;
                      final leftPage = widget.viewModel.pages[index];
                      final rightPage = widget.viewModel.pages[index - 1];
                      if (leftPage == null || rightPage == null) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Row(
                          mainAxisAlignment: .center,
                          children: [
                            Image.memory(leftPage),
                            Image.memory(rightPage),
                          ],
                        );
                      }
                    }
                  },
                  itemCount: orientation == .portrait
                      ? widget.viewModel.book.pageCount!
                      : widget.viewModel.book.pageCount! % 2 == 0
                      ? ((widget.viewModel.book.pageCount! - 2) / 2).toInt()
                      : ((widget.viewModel.book.pageCount! - 1) / 2).toInt(),
                  onPageChanged: (value) {
                    if (orientation == _orientation) {
                      if (orientation == .landscape) {
                        value = value * 2;
                      }
                      widget.viewModel.setCurrentPage.execute(value);
                      if (_menuVisible) {
                        SystemChrome.setEnabledSystemUIMode(.immersiveSticky);
                        setState(() {
                          _menuVisible = false;
                        });
                      }
                    }
                  },
                  pageSnapping: widget.viewModel.readingMode != .continuous,
                  reverse: widget.viewModel.readingDirection == .rightToLeft,
                  scrollDirection:
                      widget.viewModel.readingDirection == .vertical
                      ? .vertical
                      : .horizontal,
                ),
                GestureDetector(
                  onTap: () {
                    if (_menuVisible) {
                      SystemChrome.setEnabledSystemUIMode(.immersiveSticky);
                      setState(() {
                        _menuVisible = false;
                      });
                    } else {
                      SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
                      setState(() {
                        _menuVisible = true;
                      });
                    }
                  },
                ),
                Center(
                  child: AspectRatio(
                    aspectRatio: orientation == .portrait
                        ? widget.viewModel.book.aspectRatio!
                        : 1 / widget.viewModel.book.aspectRatio!,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.viewModel.readingDirection ==
                                  .rightToLeft) {
                                widget.viewModel.pageController.nextPage(
                                  duration: widget.viewModel.duration,
                                  curve: widget.viewModel.curve,
                                );
                              } else {
                                widget.viewModel.pageController.previousPage(
                                  duration: widget.viewModel.duration,
                                  curve: widget.viewModel.curve,
                                );
                              }
                            },
                          ),
                        ),
                        Expanded(flex: 2, child: SizedBox.shrink()),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.viewModel.readingDirection ==
                                  .rightToLeft) {
                                widget.viewModel.pageController.previousPage(
                                  duration: widget.viewModel.duration,
                                  curve: widget.viewModel.curve,
                                );
                              } else {
                                widget.viewModel.pageController.nextPage(
                                  duration: widget.viewModel.duration,
                                  curve: widget.viewModel.curve,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_menuVisible) ReaderMenu(viewModel: widget.viewModel),
              ],
            );
          },
        );
      },
    );
  }
}
