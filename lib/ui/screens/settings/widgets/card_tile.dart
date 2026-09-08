import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  const CardTile({
    super.key,
    this.enabled = true,
    this.leading,
    this.onTap,
    this.subtitle,
    this.title,
    this.trailing,
  });

  final bool enabled;
  final Widget? leading;
  final void Function()? onTap;
  final Widget? subtitle;
  final Widget? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      enabled: enabled,
      leading: leading,
      onTap: onTap,
      subtitle: subtitle,
      title: title,
      trailing: trailing,
    );
  }
}
