import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../utils/command.dart';

class LinkTile extends StatelessWidget {
  final String? info;
  final Command1<void, Uri> openLink;
  final String? title;
  final Uri uri;

  const LinkTile({
    this.info,
    super.key,
    required this.openLink,
    this.title,
    required this.uri,
  });

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
        if (info != null)
          RichText(
            text: TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  openLink.execute(uri);
                },
              style: TextTheme.of(
                context,
              ).bodyLarge!.copyWith(color: ColorScheme.of(context).primary),
              text: info!,
            ),
          ),
      ],
    );
  }
}
