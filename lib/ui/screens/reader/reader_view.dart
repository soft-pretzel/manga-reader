import 'package:material_ui/material_ui.dart';
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
  Animation<Matrix4>? _animation;
  late AnimationController _animationController;
  bool _enableScroll = true;
  bool _menuVisible = false;
  late Orientation _orientation;
  final _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _animationController =
        AnimationController(duration: widget.viewModel.duration, vsync: this)
          ..addListener(() {
            _transformationController.value = _animation?.value ?? .identity();
          });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _orientation = MediaQuery.of(context).orientation;
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
    _animationController.dispose();
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
                  maxScale: widget.viewModel.zoom,
                  minScale: 1.0,
                  onInteractionEnd: (details) {
                    if (_transformationController.value.row0[0] == 1.0) {
                      setState(() {
                        _enableScroll = true;
                      });
                    } else {
                      setState(() {
                        _enableScroll = false;
                      });
                    }
                  },
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
                    physics: _enableScroll && !widget.viewModel.ereaderMode
                        ? null
                        : NeverScrollableScrollPhysics(),
                    reverse: widget.viewModel.readingDirection == .rightToLeft,
                    scrollDirection:
                        widget.viewModel.readingDirection == .vertical
                        ? .vertical
                        : .horizontal,
                  ),
                ),
                GestureDetector(
                  onDoubleTapDown: (details) {
                    if (_transformationController.value != .identity()) {
                      setState(() {
                        _enableScroll = true;
                      });
                      if (!widget.viewModel.ereaderMode) {
                        _animation =
                            Matrix4Tween(
                              begin: _transformationController.value,
                              end: .identity(),
                            ).animate(
                              CurveTween(curve: widget.viewModel.curve)
                                  .animate(_animationController),
                            );
                        _animationController.forward(from: 0);
                      } else {
                        _transformationController.value = .identity();
                      }
                    } else {
                      setState(() {
                        _enableScroll = false;
                      });
                      final matrix = Matrix4.identity()
                        ..translateByDouble(
                          -details.globalPosition.dx,
                          -details.globalPosition.dy,
                          1,
                          1,
                        )
                        ..scaleByDouble(
                          widget.viewModel.zoom,
                          widget.viewModel.zoom,
                          1,
                          1,
                        );
                      if (!widget.viewModel.ereaderMode) {
                        _animation =
                            Matrix4Tween(
                              begin: .identity(),
                              end: matrix,
                            ).animate(
                              CurveTween(curve: widget.viewModel.curve)
                                  .animate(_animationController),
                            );
                        _animationController.forward(from: 0);
                      } else {
                        _transformationController.value = matrix;
                      }
                    }
                  },
                  onHorizontalDragEnd:
                      widget.viewModel.ereaderMode && _enableScroll
                      ? (details) {
                          int index = widget.viewModel.mainPageController.page!
                              .toInt();
                          if (details.primaryVelocity! > 0) {
                            if (widget.viewModel.readingDirection ==
                                .rightToLeft) {
                              index++;
                            } else {
                              index--;
                            }
                            widget.viewModel.mainPageController.jumpToPage(
                              index,
                            );
                          }
                          if (widget.viewModel.readingDirection ==
                              .rightToLeft) {
                            index--;
                          } else {
                            index++;
                          }
                          if (details.primaryVelocity! < 0) {
                            widget.viewModel.mainPageController.jumpToPage(
                              index,
                            );
                          }
                        }
                      : null,
                  onLongPressEnd: !widget.viewModel.ereaderMode
                      ? (details) {
                          _animation =
                              Matrix4Tween(
                                begin: _transformationController.value,
                                end: .identity(),
                              ).animate(
                                CurveTween(curve: widget.viewModel.curve)
                                    .animate(_animationController),
                              );
                          _animationController.forward(from: 0);
                        }
                      : null,
                  onLongPressMoveUpdate: !widget.viewModel.ereaderMode
                      ? (details) {
                          _transformationController.value = .identity()
                            ..translateByDouble(
                              (-details.globalPosition.dx *
                                      (widget.viewModel.zoom - 1)) -
                                  details.localOffsetFromOrigin.dx * 12,
                              (-details.globalPosition.dy *
                                      (widget.viewModel.zoom - 1)) -
                                  details.localOffsetFromOrigin.dy * 12,
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
                      : null,
                  onLongPressStart: !widget.viewModel.ereaderMode
                      ? (details) {
                          final matrix = Matrix4.identity()
                            ..translateByDouble(
                              -details.globalPosition.dx,
                              -details.globalPosition.dy,
                              1,
                              1,
                            )
                            ..scaleByDouble(
                              widget.viewModel.zoom,
                              widget.viewModel.zoom,
                              1,
                              1,
                            );
                          _animation =
                              Matrix4Tween(
                                begin: .identity(),
                                end: matrix,
                              ).animate(
                                CurveTween(curve: widget.viewModel.curve)
                                    .animate(_animationController),
                              );
                          _animationController.forward(from: 0);
                        }
                      : null,
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
                              int index = widget
                                  .viewModel
                                  .mainPageController
                                  .page!
                                  .toInt();
                              if (widget.viewModel.readingDirection ==
                                  .rightToLeft) {
                                index++;
                              } else {
                                index--;
                              }
                              if (widget.viewModel.ereaderMode) {
                                widget.viewModel.mainPageController.jumpToPage(
                                  index,
                                );
                              } else {
                                widget.viewModel.mainPageController
                                    .animateToPage(
                                      index,
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
                              int index = widget
                                  .viewModel
                                  .mainPageController
                                  .page!
                                  .toInt();
                              if (widget.viewModel.readingDirection ==
                                  .rightToLeft) {
                                index--;
                              } else {
                                index++;
                              }
                              if (widget.viewModel.ereaderMode) {
                                widget.viewModel.mainPageController.jumpToPage(
                                  index,
                                );
                              } else {
                                widget.viewModel.mainPageController
                                    .animateToPage(
                                      index,
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
