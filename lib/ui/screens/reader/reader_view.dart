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
  late final PageController _pageController;
  var _scrollPhysics = ScrollPhysics();
  final _transformationController = TransformationController();
  var _tapDownDetails = TapDownDetails();
  bool _zoomedIn = false;

  Future<void> _initController() async {
    await widget.viewModel.getCurrentPage.execute();
    _pageController = PageController(initialPage: widget.viewModel.currentPage);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initController();
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
              final position = details.globalPosition;
              _transformationController.value = Matrix4.identity()
                ..translateByDouble(-position.dx * 2, -position.dy * 2, 1, 1)
                ..scaleByDouble(3, 3, 1, 1);
            },
            onLongPressEnd: (details) {
              _transformationController.value = Matrix4.identity();
            },
            child: InteractiveViewer(
              transformationController: _transformationController,
              child: PageView(
                controller: _pageController,
                physics: _scrollPhysics,
                // onPageChanged: _onPageChanged,
                reverse: (widget.viewModel.readingDirection == .leftToRight)
                    ? false
                    : true,
                children: [
                  for (final page in widget.viewModel.pages)
                    Image.file(File(page)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
