import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes.dart';
import '../reader_view_model.dart';

class ReaderMenu extends StatefulWidget {
  final ReaderViewModel viewModel;

  const ReaderMenu({super.key, required this.viewModel});

  @override
  State<ReaderMenu> createState() => _ReaderMenuState();
}

class _ReaderMenuState extends State<ReaderMenu> {
  late int _currentPage;
  late PageController _controller;
  final _menuController = MenuController();
  bool _sliding = false;

  Widget _page(int index, {int? goToIndex}) {
    final page = widget.viewModel.pages[index];
    if (page == null) {
      return Center(child: CircularProgressIndicator());
    }
    return GestureDetector(
      onTap: () {
        if (widget.viewModel.ereaderMode) {
          widget.viewModel.mainPageController.jumpToPage(goToIndex ?? index);
        } else {
          widget.viewModel.mainPageController.animateToPage(
            goToIndex ?? index,
            duration: widget.viewModel.duration,
            curve: widget.viewModel.curve,
          );
        }
      },
      child: Image.memory(page),
    );
  }

  @override
  void initState() {
    _currentPage = widget.viewModel.book.currentPage;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        _controller = PageController(
          initialPage: widget.viewModel.readingMode == .double
              ? (widget.viewModel.book.currentPage / 2).toInt()
              : widget.viewModel.book.currentPage - 1,
          viewportFraction: () {
            if (orientation == .landscape) {
              if (widget.viewModel.readingMode == .double) {
                return 1 / 4;
              } else {
                return 1 / 8;
              }
            } else {
              if (widget.viewModel.readingMode == .double) {
                return 1 / 2;
              } else {
                return 1 / 4;
              }
            }
          }(),
        );
        return Column(
          children: [
            Card(
              margin: .all(0),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      color: ColorScheme.of(context).primary,
                      onPressed: () => context..pop(),
                      icon: Icon(Icons.arrow_back),
                    ),
                    Text(widget.viewModel.book.title),
                    Spacer(),
                    MenuAnchor(
                      controller: _menuController,
                      menuChildren: [
                        MenuItemButton(
                          onPressed: () {
                            if (context.mounted) {
                              context.pushNamed(
                                RouteNames.book,
                                pathParameters: {
                                  'bookId': widget.viewModel.book.id,
                                },
                              );
                            }
                          },
                          child: Text('Book details'),
                        ),
                        MenuItemButton(
                          onPressed: () {
                            context.goNamed(RouteNames.readerSettings);
                          },
                          child: Text('Reader settings'),
                        ),
                      ],
                      child: IconButton(
                        color: ColorScheme.of(context).primary,
                        onPressed: () => _menuController.open(),
                        icon: Icon(Icons.more_vert_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  IgnorePointer(
                    child: Container(
                      color: ColorScheme.of(context).surface.withAlpha(128),
                    ),
                  ),
                  Align(
                    alignment: .bottomCenter,
                    child: Padding(
                      padding: .only(bottom: 8),
                      child: SizedBox(
                        height: 150,
                        child: PageView.builder(
                          controller: _controller,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _page(index);
                            }
                            if (widget.viewModel.readingMode == .double) {
                              index = index * 2;
                              if (widget.viewModel.book.pageCount! % 2 == 0 &&
                                  index == widget.viewModel.book.pageCount!) {
                                if (orientation == .portrait) {
                                  return _page(index - 1);
                                } else {
                                  return _page(
                                    index - 1,
                                    goToIndex: (index / 2).toInt(),
                                  );
                                }
                              }
                              if (orientation == .portrait) {
                                return Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    if (widget.viewModel.readingDirection ==
                                        .rightToLeft) ...[
                                      _page(index),
                                      _page(index - 1),
                                    ] else ...[
                                      _page(index - 1),
                                      _page(index),
                                    ],
                                  ],
                                );
                              } else {
                                return Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    if (widget.viewModel.readingDirection ==
                                        .rightToLeft) ...[
                                      _page(
                                        index,
                                        goToIndex: (index / 2).toInt(),
                                      ),
                                      _page(
                                        index - 1,
                                        goToIndex: (index / 2).toInt(),
                                      ),
                                    ] else ...[
                                      _page(
                                        index - 1,
                                        goToIndex: (index / 2).toInt(),
                                      ),
                                      _page(
                                        index,
                                        goToIndex: (index / 2).toInt(),
                                      ),
                                    ],
                                  ],
                                );
                              }
                            }
                            return _page(index);
                          },
                          itemCount: widget.viewModel.readingMode == .double
                              ? widget.viewModel.book.pageCount! % 2 == 0
                                    ? ((widget.viewModel.book.pageCount! - 2) /
                                                  2)
                                              .toInt() +
                                          2
                                    : ((widget.viewModel.book.pageCount! - 1) /
                                                  2)
                                              .toInt() +
                                          1
                              : widget.viewModel.book.pageCount!,
                          onPageChanged: (value) {
                            if (!_sliding) {
                              if (widget.viewModel.readingMode == .double) {
                                value = value * 2;
                                if (value == 0) value++;
                              } else {
                                value++;
                              }
                              setState(() {
                                _currentPage = value;
                              });
                            }
                          },
                          pageSnapping: false,
                          reverse:
                              widget.viewModel.readingDirection == .rightToLeft,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: .all(0),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Padding(
                      padding: .only(top: 8),
                      child: Text(
                        '$_currentPage / ${widget.viewModel.book.pageCount}',
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          color: ColorScheme.of(context).primary,
                          onPressed: () {
                            setState(() {
                              widget.viewModel.undo.add(
                                widget.viewModel.book.currentPage,
                              );
                            });
                            int value;
                            if (widget.viewModel.readingDirection ==
                                .rightToLeft) {
                              value = widget.viewModel.book.pageCount! - 1;
                              if (orientation == .landscape) {
                                value = (value / 2).toInt();
                                if (widget.viewModel.book.pageCount! % 2 == 0) {
                                  value++;
                                }
                              }
                            } else {
                              value = 0;
                            }
                            if (widget.viewModel.ereaderMode) {
                              widget.viewModel.mainPageController.jumpToPage(
                                value,
                              );
                            } else {
                              widget.viewModel.mainPageController.animateToPage(
                                value,
                                duration: widget.viewModel.duration,
                                curve: widget.viewModel.curve,
                              );
                            }
                          },
                          icon: Icon(Icons.first_page_rounded),
                        ),
                        Expanded(
                          child: Directionality(
                            textDirection:
                                widget.viewModel.readingDirection ==
                                    .rightToLeft
                                ? .rtl
                                : .ltr,
                            child: Slider(
                              max: widget.viewModel.book.pageCount!.toDouble(),
                              min: 1,
                              value: _currentPage.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  _sliding = true;
                                  _currentPage = value.toInt();
                                });
                                if (widget.viewModel.readingMode == .double) {
                                  value = value / 2;
                                } else {
                                  value--;
                                }
                                if (widget.viewModel.ereaderMode) {
                                  _controller.jumpToPage((value).toInt());
                                } else {
                                  _controller.animateToPage(
                                    (value).toInt(),
                                    duration: widget.viewModel.duration,
                                    curve: widget.viewModel.curve,
                                  );
                                }
                              },
                              onChangeEnd: (value) {
                                setState(() {
                                  widget.viewModel.undo.add(
                                    widget.viewModel.book.currentPage,
                                  );
                                });
                                if (orientation == .landscape) {
                                  value = value / 2;
                                } else {
                                  value--;
                                }
                                if (widget.viewModel.ereaderMode) {
                                  widget.viewModel.mainPageController
                                      .jumpToPage((value).toInt());
                                } else {
                                  widget.viewModel.mainPageController
                                      .animateToPage(
                                        (value).toInt(),
                                        duration: widget.viewModel.duration,
                                        curve: widget.viewModel.curve,
                                      );
                                }
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          color: ColorScheme.of(context).primary,
                          icon: Icon(Icons.undo_rounded),
                          onPressed: widget.viewModel.undo.isNotEmpty
                              ? () {
                                  int value = widget.viewModel.undo
                                      .removeLast();
                                  if (orientation == .landscape) {
                                    value = (value / 2).toInt();
                                  } else {
                                    value--;
                                  }
                                  if (widget.viewModel.ereaderMode) {
                                    widget.viewModel.mainPageController
                                        .jumpToPage(value);
                                  } else {
                                    widget.viewModel.mainPageController
                                        .animateToPage(
                                          value,
                                          duration: widget.viewModel.duration,
                                          curve: widget.viewModel.curve,
                                        );
                                  }
                                }
                              : null,
                        ),
                        IconButton(
                          color: ColorScheme.of(context).primary,
                          onPressed: () {
                            setState(() {
                              widget.viewModel.undo.add(
                                widget.viewModel.book.currentPage,
                              );
                            });
                            int value;
                            if (widget.viewModel.readingDirection ==
                                .rightToLeft) {
                              value = 0;
                            } else {
                              value = widget.viewModel.book.pageCount! - 1;
                              if (orientation == .landscape) {
                                value = (value / 2).toInt();
                                if (widget.viewModel.book.pageCount! % 2 == 0) {
                                  value++;
                                }
                              }
                            }
                            if (widget.viewModel.ereaderMode) {
                              widget.viewModel.mainPageController.jumpToPage(
                                value,
                              );
                            } else {
                              widget.viewModel.mainPageController.animateToPage(
                                value,
                                duration: widget.viewModel.duration,
                                curve: widget.viewModel.curve,
                              );
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
      },
    );
  }
}
