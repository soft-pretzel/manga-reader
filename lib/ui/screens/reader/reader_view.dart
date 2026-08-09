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
  int _index = 0;
  Orientation? _orientation;
  late PageController _pageController;
  var _scrollPhysics = ScrollPhysics();
  final _transformationController = TransformationController();
  var _tapDownDetails = TapDownDetails();
  bool _zoomedIn = false;

  Future<void> _initController() async {
    await widget.viewModel.getCurrentPage.execute();
    _pageController = PageController(initialPage: widget.viewModel.currentPage);
  }

  void _updatePageController(Orientation orientation) {
    if (orientation == .landscape) {
      if (widget.viewModel.currentPage % 2 == 0) {
        _pageController.jumpToPage(widget.viewModel.currentPage - 1);
      }
      _pageController = PageController(
        viewportFraction:
            (widget.viewModel.currentPage == 0 ||
                widget.viewModel.currentPage ==
                    widget.viewModel.pages.length - 1)
            ? 1
            : 1 / 2,
      );
    } else {
      _pageController = PageController();
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orientation ??= MediaQuery.orientationOf(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              Navigator.of(context).push(
                ReaderMenu(
                  pageController: _pageController,
                  viewModel: widget.viewModel,
                ),
              );
            },
            onDoubleTapDown: (details) => _tapDownDetails = details,
            onDoubleTap: () {
              if (_zoomedIn) {
                _transformationController.value = Matrix4.identity();
                setState(() {
                  _scrollPhysics = PageScrollPhysics();
                });
                _zoomedIn = false;
              } else {
                final position = _tapDownDetails.localPosition;
                _transformationController.value = Matrix4.identity()
                  ..translateByDouble(-position.dx * 2, -position.dy * 2, 1, 1)
                  ..scaleByDouble(3, 3, 1, 1);
                setState(() {
                  _scrollPhysics = NeverScrollableScrollPhysics();
                });
                _zoomedIn = true;
              }
            },
            onLongPressStart: (details) {
              final position = details.localPosition;
              _transformationController.value = Matrix4.identity()
                ..translateByDouble(-position.dx * 2, -position.dy * 2, 1, 1)
                ..scaleByDouble(3, 3, 1, 1);
            },
            onLongPressMoveUpdate: (details) {
              final origin = details.localOffsetFromOrigin;
              final position = details.localPosition;
              _transformationController.value = Matrix4.identity()
                ..translateByDouble(
                  (-position.dx * 2) - origin.dx * 10,
                  (-position.dy * 2) - origin.dy * 10,
                  1,
                  1,
                )
                ..scaleByDouble(3, 3, 1, 1);
            },
            onLongPressEnd: (details) {
              _transformationController.value = Matrix4.identity();
            },
            child: InteractiveViewer(
              transformationController: _transformationController,
              child: OrientationBuilder(
                builder: (context, orientation) {
                  if (orientation != _orientation) {
                    _updatePageController(orientation);
                    _orientation = orientation;
                  }
                  return PageView(
                    controller: _pageController,
                    physics: _scrollPhysics,
                    padEnds: false,
                    onPageChanged: (newPage) {
                      widget.viewModel.currentPage = newPage;
                    },
                    reverse: (widget.viewModel.readingDirection == .rightToLeft)
                        ? true
                        : false,
                    scrollDirection:
                        (widget.viewModel.readingDirection == .vertical)
                        ? Axis.vertical
                        : Axis.horizontal,
                    children: [
                      for (final page in widget.viewModel.pages)
                        Image.file(
                          File(page),
                          alignment: () {
                            if (_index == 0 ||
                                _index + 1 == widget.viewModel.pages.length) {
                              _index++;
                              return Alignment.center;
                            }
                            if (_index % 2 == 0) {
                              _index++;
                              return Alignment.centerRight;
                            } else {
                              _index++;
                              return Alignment.centerLeft;
                            }
                          }(),
                        ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
