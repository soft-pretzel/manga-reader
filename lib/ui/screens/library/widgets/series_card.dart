import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../library_view_model.dart';
import '../../../../data/models/series_model.dart';
import '../../../../routing/routes.dart';

class SeriesCard extends StatelessWidget {
  const SeriesCard({super.key, required this.series, required this.viewModel});

  final SeriesModel series;
  final LibraryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 4,
          child: Card(
            margin: EdgeInsets.all(0),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              child: Thumbnail(series: series, viewModel: viewModel),
              onTap: () {
                context.pushNamed(
                  RouteNames.series,
                  pathParameters: {'seriesId': series.id},
                );
              },
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      text: series.name,
                    ),
                  ),
                  BookCount(series: series, viewModel: viewModel),
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

  final SeriesModel series;
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

  final SeriesModel series;
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
