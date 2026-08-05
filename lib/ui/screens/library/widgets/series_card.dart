import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/series_model.dart';
import '../../../../routing/routes.dart';

class SeriesCard extends StatelessWidget {
  const SeriesCard({super.key, required this.series});

  final SeriesModel series;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: () {
          if (series.thumbnail != null) {
            return Image.file(File(series.thumbnail!));
          } else {
            return Center(child: Text(series.name));
          }
        }(),
        onTap: () {
          context.pushNamed(
            RouteNames.series,
            pathParameters: {'seriesId': series.id},
          );
        },
      ),
    );
  }
}
