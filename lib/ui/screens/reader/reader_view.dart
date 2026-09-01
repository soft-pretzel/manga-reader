import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'reader_view_model.dart';
import 'widgets/reader_menu.dart';
import 'widgets/stagger_animation.dart';

class ReaderView extends StatefulWidget {
  const ReaderView({super.key, required this.viewModel});

  final ReaderViewModel viewModel;

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  Orientation? _currentOrientation;
  late PageController _pageController;
  double _scaleBegin = 1;
  double? _scaleEnd;
  var _scrollPhysics = ScrollPhysics();
  late Size _size;
  final _transformationController = TransformationController();
  var _tapDownDetails = TapDownDetails();
  double? _xBegin;
  double? _xEnd;
  double? _yBegin;
  double? _yEnd;

  Future<void> _initControllers() async {
    await widget.viewModel.loadBook.execute();
    var pageIndex = widget.viewModel.book.currentPage - 1;
    if (_currentOrientation == .landscape) pageIndex = (pageIndex / 2).round();
    _pageController = PageController(initialPage: pageIndex);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 1, curve: Curves.easeInOut),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initControllers();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation ??= MediaQuery.orientationOf(context);
    _size = MediaQuery.sizeOf(context);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    widget.viewModel.brightnessReset.execute();
    _animationController.dispose();
    _pageController.dispose();
    _transformationController.dispose();
    widget.viewModel.setReadingStatus.execute();
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
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                Text('Error loading Reader'),
                TextButton(
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
          return OrientationBuilder(
            builder: (context, newOrientation) {
              if (_currentOrientation != newOrientation) {
                _currentOrientation = newOrientation;
                var pageIndex = widget.viewModel.book.currentPage - 1;
                if (newOrientation == .landscape) {
                  pageIndex = (pageIndex / 2).round();
                }
                _pageController.jumpToPage(pageIndex);
              }
              return GestureDetector(
                onTapDown: (details) => _tapDownDetails = details,
                onTap: () {
                  final x = _tapDownDetails.localPosition.dx;
                  if (x >= (_size.width * 3 / 4)) {
                    if (widget.viewModel.readingDirection == .rightToLeft) {
                      if (widget.viewModel.animations) {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _pageController.jumpToPage(
                          (_pageController.page! - 1).toInt(),
                        );
                      }
                    } else {
                      if (widget.viewModel.animations) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _pageController.jumpToPage(
                          (_pageController.page! + 1).toInt(),
                        );
                      }
                    }
                  } else if (x <= (_size.width / 4)) {
                    if (widget.viewModel.readingDirection == .rightToLeft) {
                      if (widget.viewModel.animations) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _pageController.jumpToPage(
                          (_pageController.page! + 1).toInt(),
                        );
                      }
                    } else {
                      if (widget.viewModel.animations) {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _pageController.jumpToPage(
                          (_pageController.page! - 1).toInt(),
                        );
                      }
                    }
                  } else {
                    SystemChrome.setEnabledSystemUIMode(
                      SystemUiMode.edgeToEdge,
                    );
                    Navigator.of(context).push(
                      ReaderMenu(
                        orientation: newOrientation,
                        pageController: _pageController,
                        viewModel: widget.viewModel,
                      ),
                    );
                  }
                },
                onDoubleTapDown: (widget.viewModel.doubleTapZoom)
                    ? (details) => _tapDownDetails = details
                    : null,
                onDoubleTap: (widget.viewModel.doubleTapZoom)
                    ? () async {
                        if (_scaleEnd == widget.viewModel.zoom) {
                          setState(() {
                            _scaleBegin = widget.viewModel.zoom;
                            _scaleEnd = 1;
                            _xBegin = _xEnd;
                            _xEnd = 0;
                            _yBegin = _yEnd;
                            _yEnd = 0;
                            _scrollPhysics = PageScrollPhysics();
                          });
                          await _animationController.forward(from: 0);
                        } else {
                          final position = _tapDownDetails.localPosition;
                          setState(() {
                            _scaleBegin = 1;
                            _scaleEnd = widget.viewModel.zoom;
                            _xBegin = 0;
                            _xEnd = -position.dx * (widget.viewModel.zoom - 1);
                            _yBegin = 0;
                            _yEnd = -position.dy * (widget.viewModel.zoom - 1);
                            _scrollPhysics = NeverScrollableScrollPhysics();
                          });
                          await _animationController.forward(from: 0);
                        }
                      }
                    : null,
                onLongPressStart: (details) async {
                  setState(() {
                    _scaleBegin = 1;
                    _scaleEnd = widget.viewModel.zoom;
                    _xBegin = 0;
                    _xEnd = -(_size.width / 2) * (widget.viewModel.zoom - 1);
                    _yBegin = 0;
                    _yEnd = -(_size.height / 2) * (widget.viewModel.zoom - 1);
                  });
                  await _animationController.forward(from: 0);
                },
                onLongPressMoveUpdate: (details) {
                  final offset = details.offsetFromOrigin;
                  setState(() {
                    _animationController.duration = Duration(milliseconds: 200);
                    _scaleBegin = widget.viewModel.zoom;
                    _xBegin = _xEnd;
                    _xEnd =
                        (-_size.width / 2 * (widget.viewModel.zoom - 1)) -
                        offset.dx * 10;
                    _yBegin = _yEnd;
                    _yEnd =
                        (-_size.height / 2 * (widget.viewModel.zoom - 1)) -
                        offset.dy * 10;
                  });
                  if (!_animationController.isAnimating) {
                    _animationController.forward(from: 0);
                  }
                },
                onLongPressEnd: (details) async {
                  setState(() {
                    _animationController.duration = Duration(milliseconds: 200);
                    _scaleBegin = widget.viewModel.zoom;
                    _scaleEnd = 1;
                    _xBegin = _xEnd;
                    _xEnd = 0;
                    _yBegin = _yEnd;
                    _yEnd = 0;
                  });
                  await _animationController.forward(from: 0);
                },
                onVerticalDragUpdate: (details) {
                  final x = details.localPosition.dx;
                  if (x >= (_size.width * 3 / 4)) {
                    final delta = -details.delta.dy;
                    if (delta > 1) {
                      widget.viewModel.brightnessUp.execute();
                    } else if (delta < -1) {
                      widget.viewModel.brightnessDown.execute();
                    }
                  }
                },
                child: StaggerAnimation(
                  animation: _animation,
                  animationController: _animationController,
                  scaleBegin: _scaleBegin,
                  transformationController: _transformationController,
                  xBegin: _xBegin,
                  xEnd: _xEnd,
                  yBegin: _yBegin,
                  yEnd: _yEnd,
                  scaleEnd: _scaleEnd ?? widget.viewModel.zoom,
                  child: PageView.builder(
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      if (newOrientation == .portrait) {
                        return Image.file(File(widget.viewModel.pages[index]));
                      } else {
                        if (index == 0) {
                          return Image.file(File(widget.viewModel.pages.first));
                        } else {
                          index = index * 2;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.file(File(widget.viewModel.pages[index])),
                              Image.file(
                                File(widget.viewModel.pages[index - 1]),
                              ),
                            ],
                          );
                        }
                      }
                    },
                    itemCount: (newOrientation == .portrait)
                        ? widget.viewModel.pages.length
                        : ((widget.viewModel.pages.length / 2) + 1).toInt(),
                    onPageChanged: (pageIndex) {
                      if (_currentOrientation == newOrientation) {
                        if (_currentOrientation == .landscape) {
                          pageIndex = pageIndex * 2 - 1;
                          if (pageIndex == 0) pageIndex = 0;
                        }
                        widget.viewModel.updateBook.execute(pageIndex + 1);
                      }
                    },
                    pageSnapping: (widget.viewModel.readingMode == .continuous)
                        ? false
                        : true,
                    physics: _scrollPhysics,
                    reverse: (widget.viewModel.readingDirection == .rightToLeft)
                        ? true
                        : false,
                    scrollDirection:
                        (widget.viewModel.readingDirection == .vertical)
                        ? Axis.vertical
                        : Axis.horizontal,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
