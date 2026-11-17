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
  final _transformationController = TransformationController();

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
    _transformationController.dispose();
    widget.viewModel.setReadingStatus.execute();
    widget.viewModel.mainPageController.dispose();
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
              widget.viewModel.mainPageController.jumpToPage(index);
            }
            return Stack(
              children: [
                InteractiveViewer(
                  transformationController: _transformationController,
                  child: PageView.builder(
                    controller: widget.viewModel.mainPageController,
                    itemBuilder: (context, index) {
                      Widget page(int index) {
                        if (widget.viewModel.pages[index] == null) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Image.memory(widget.viewModel.pages[index]!);
                      }

                      if (index == 0) {
                        return page(index);
                      }
                      if (orientation == .landscape) {
                        index = index * 2;
                        if (widget.viewModel.book.pageCount! % 2 == 0 &&
                            index == widget.viewModel.book.pageCount!) {
                          return page(index - 1);
                        }
                        return Row(
                          mainAxisAlignment: .center,
                          children: [
                            if (widget.viewModel.readingDirection ==
                                .rightToLeft) ...[
                              page(index),
                              page(index - 1),
                            ] else ...[
                              page(index - 1),
                              page(index),
                            ],
                          ],
                        );
                      }
                      return page(index);
                    },
                    itemCount: orientation == .portrait
                        ? widget.viewModel.book.pageCount!
                        : widget.viewModel.book.pageCount! % 2 == 0
                        ? ((widget.viewModel.book.pageCount! - 2) / 2).toInt() +
                              2
                        : ((widget.viewModel.book.pageCount! - 1) / 2).toInt() +
                              1,
                    onPageChanged: (value) {
                      if (orientation == _orientation) {
                        if (orientation == .landscape) {
                          value = value * 2;
                          if (value == 0) value++;
                        } else {
                          value++;
                        }
                        widget.viewModel.updateBook.execute(value);
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
                ),
                GestureDetector(
                  onDoubleTapDown: (details) {
                    setState(() {
                      if (_transformationController.value != .identity()) {
                        _transformationController.value = .identity();
                      } else {
                        _transformationController.value = .identity()
                          ..translateByDouble(
                            -details.globalPosition.dx *
                                (widget.viewModel.zoom - 1),
                            -details.globalPosition.dy *
                                (widget.viewModel.zoom - 1),
                            1,
                            1,
                          )
                          ..scaleByDouble(
                            widget.viewModel.zoom,
                            widget.viewModel.zoom,
                            1,
                            1,
                          );
                      }
                    });
                  },
                  onLongPressEnd: (details) {
                    _transformationController.value = .identity();
                  },
                  onLongPressMoveUpdate: (details) {
                    _transformationController.value = .identity()
                      ..translateByDouble(
                        (-details.globalPosition.dx *
                                (widget.viewModel.zoom - 1)) -
                            details.offsetFromOrigin.dx * 10,
                        (-details.globalPosition.dy *
                                (widget.viewModel.zoom - 1)) -
                            details.offsetFromOrigin.dy * 10,
                        1,
                        1,
                      )
                      ..scaleByDouble(
                        widget.viewModel.zoom,
                        widget.viewModel.zoom,
                        1,
                        1,
                      );
                  },
                  onLongPressStart: (details) {
                    _transformationController.value = .identity()
                      ..translateByDouble(
                        -details.globalPosition.dx *
                            (widget.viewModel.zoom - 1),
                        -details.globalPosition.dy *
                            (widget.viewModel.zoom - 1),
                        1,
                        1,
                      )
                      ..scaleByDouble(
                        widget.viewModel.zoom,
                        widget.viewModel.zoom,
                        1,
                        1,
                      );
                  },
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
                                widget.viewModel.mainPageController.nextPage(
                                  duration: widget.viewModel.duration,
                                  curve: widget.viewModel.curve,
                                );
                              } else {
                                widget.viewModel.mainPageController
                                    .previousPage(
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
                                widget.viewModel.mainPageController
                                    .previousPage(
                                      duration: widget.viewModel.duration,
                                      curve: widget.viewModel.curve,
                                    );
                              } else {
                                widget.viewModel.mainPageController.nextPage(
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
