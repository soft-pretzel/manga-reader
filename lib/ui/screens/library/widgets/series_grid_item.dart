import 'package:flutter/material.dart';

class SeriesGridItem extends StatelessWidget {
  const SeriesGridItem({super.key, required this.series});

  final String series;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('test');
      },
      child: Card(child: Text(series)),
    );
  }
}
