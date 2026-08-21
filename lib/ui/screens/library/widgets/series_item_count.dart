import 'package:flutter/material.dart';

import '../library_view_model.dart';
import '../../../../data/models/series.dart';

class SeriesItemCount extends StatefulWidget {
  const SeriesItemCount({
    super.key,
    required this.series,
    required this.viewModel,
  });

  final Series series;
  final LibraryViewModel viewModel;

  @override
  State<SeriesItemCount> createState() => _SeriesItemCountState();
}

class _SeriesItemCountState extends State<SeriesItemCount> {
  @override
  void initState() {
    super.initState();
    if (widget.series.bookCount == null) {
      widget.viewModel.getSeriesItemCount.execute(widget.series);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.getSeriesItemCount,
      builder: (context, child) {
        if (widget.viewModel.getSeriesItemCount.running) {
          return Center(child: CircularProgressIndicator());
        }

        if (widget.viewModel.getSeriesItemCount.error) {
          return Center(
            child: Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
          );
        }

        return Positioned(
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
                  Theme.of(context).colorScheme.surface.withAlpha(224),
                  Theme.of(context).colorScheme.surface.withAlpha(0),
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
                    style: DefaultTextStyle.of(
                      context,
                    ).style.apply(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
