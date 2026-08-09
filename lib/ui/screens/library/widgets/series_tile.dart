import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_reader/ui/screens/library/widgets/series_menu.dart';

import '../library_view_model.dart';
import '../../../../data/models/series.dart';
import '../../../../routing/routes.dart';

class SeriesTile extends StatefulWidget {
  const SeriesTile({super.key, required this.series, required this.viewModel});

  final Series series;
  final LibraryViewModel viewModel;

  @override
  State<SeriesTile> createState() => _SeriesTileState();
}

class _SeriesTileState extends State<SeriesTile> {
  final _menuController = MenuController();

  void _handleLongPress(LongPressStartDetails details) {
    _menuController.open(position: details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 4,
          child: Card(
            margin: EdgeInsets.all(0),
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              onTap: () {
                context.pushNamed(
                  RouteNames.series,
                  pathParameters: {'seriesId': widget.series.id},
                );
              },
              onLongPressStart: _handleLongPress,
              child: SeriesMenu(
                menuController: _menuController,
                viewModel: widget.viewModel,
                child: Stack(
                  children: [
                    Thumbnail(
                      series: widget.series,
                      viewModel: widget.viewModel,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8, 64, 0, 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: AlignmentGeometry.bottomCenter,
                            end: AlignmentGeometry.topCenter,
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.surface.withAlpha(225),
                              Theme.of(
                                context,
                              ).colorScheme.surface.withAlpha(0),
                            ],
                          ),
                        ),
                        child: Wrap(
                          children: [
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: (widget.series.bookCount == 1)
                                    ? '${widget.series.bookCount} item'
                                    : '${widget.series.bookCount} items',
                                style: DefaultTextStyle.of(context).style.apply(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Align(
            alignment: AlignmentGeometry.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Wrap(
                children: [
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      text: widget.series.name,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Thumbnail extends StatefulWidget {
  const Thumbnail({super.key, required this.series, required this.viewModel});

  final Series series;
  final LibraryViewModel viewModel;

  @override
  State<Thumbnail> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.getSeriesThumbnails.execute();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.getSeriesThumbnails,
      builder: (context, child) {
        if (widget.viewModel.getSeriesThumbnails.error) {
          return Center(child: Text('Error'));
        }

        return child!;
      },
      child: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.series.thumbnail == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Image.file(File(widget.series.thumbnail!));
        },
      ),
    );
  }
}

class BookCount extends StatefulWidget {
  const BookCount({super.key, required this.series, required this.viewModel});

  final Series series;
  final LibraryViewModel viewModel;

  @override
  State<BookCount> createState() => _BookCountState();
}

class _BookCountState extends State<BookCount> {
  String _text() {
    if (widget.series.bookCount == 1) {
      return '${widget.series.bookCount?.toString()} book';
    } else {
      return '${widget.series.bookCount?.toString() ?? '0'} books';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.viewModel.getSeriesBookCount.execute();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.getSeriesBookCount,
      builder: (context, child) {
        return RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            text: _text(),
          ),
        );
      },
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // No need to redraw the shape unless it changes.
  }
}
