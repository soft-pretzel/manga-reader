import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'reader_view_model.dart';
import 'widgets/reader_menu.dart';

class ReaderView extends StatefulWidget {
  const ReaderView({super.key, required this.viewModel});

  final ReaderViewModel viewModel;

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView> {
  Orientation? _currentOrientation;
  late PageController _pageController;
  var _scrollPhysics = ScrollPhysics();
  final _transformationController = TransformationController();
  var _tapDownDetails = TapDownDetails();
  late double _width;

  Future<void> _initController() async {
    await widget.viewModel.loadBook.execute();
    var pageIndex = widget.viewModel.book.currentPage - 1;
    if (_currentOrientation == .landscape) pageIndex = (pageIndex / 2).round();
    _pageController = PageController(initialPage: pageIndex);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initController();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation ??= MediaQuery.orientationOf(context);
    _width = MediaQuery.sizeOf(context).width;
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
                  if (x >= (_width * 2 / 3)) {
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
                  } else if (x <= (_width / 3)) {
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
                onDoubleTapDown: (details) => _tapDownDetails = details,
                onDoubleTap: () {
                  if (_transformationController.value != Matrix4.identity()) {
                    _transformationController.value = Matrix4.identity();
                    setState(() {
                      _scrollPhysics = PageScrollPhysics();
                    });
                  } else {
                    final position = _tapDownDetails.localPosition;
                    _transformationController.value = Matrix4.identity()
                      ..translateByDouble(
                        -position.dx * (widget.viewModel.zoom - 1),
                        -position.dy * (widget.viewModel.zoom - 1),
                        1,
                        1,
                      )
                      ..scaleByDouble(
                        widget.viewModel.zoom,
                        widget.viewModel.zoom,
                        1,
                        1,
                      );
                    setState(() {
                      _scrollPhysics = NeverScrollableScrollPhysics();
                    });
                  }
                },
                onLongPressStart: (details) {
                  final position = details.localPosition;
                  _transformationController.value = Matrix4.identity()
                    ..translateByDouble(
                      -position.dx * (widget.viewModel.zoom - 1),
                      -position.dy * (widget.viewModel.zoom - 1),
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
                onLongPressMoveUpdate: (details) {
                  final offset = details.localOffsetFromOrigin;
                  final position = details.localPosition;
                  _transformationController.value = Matrix4.identity()
                    ..translateByDouble(
                      (-position.dx * (widget.viewModel.zoom - 1)) -
                          offset.dx * 10,
                      (-position.dy * (widget.viewModel.zoom - 1)) -
                          offset.dy * 10,
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
                onLongPressEnd: (details) {
                  _transformationController.value = Matrix4.identity();
                },
                child: InteractiveViewer(
                  transformationController: _transformationController,
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
