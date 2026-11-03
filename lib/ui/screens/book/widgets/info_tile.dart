import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String? info;
  final String? title;

  const InfoTile({this.info, super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextTheme.of(
              context,
            ).bodyLarge!.copyWith(color: ColorScheme.of(context).outline),
          ),
        if (info != null) Text(info!, style: TextTheme.of(context).bodyLarge),
      ],
    );
  }
}
