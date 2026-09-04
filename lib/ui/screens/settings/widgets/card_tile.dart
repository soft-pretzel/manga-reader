import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  const CardTile({
    super.key,
    this.leading,
    this.onTap,
    this.subtitle,
    this.title,
    this.trailing,
  });

  final Widget? leading;
  final void Function()? onTap;
  final Widget? subtitle;
  final Widget? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: leading,
      onTap: onTap,
      subtitle: subtitle,
      title: title,
      trailing: trailing,
    );
  }
}
