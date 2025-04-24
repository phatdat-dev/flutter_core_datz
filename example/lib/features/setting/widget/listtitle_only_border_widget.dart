import 'package:flutter/material.dart';

class ListtitleOnlyBorderWidget extends StatelessWidget {
  const ListtitleOnlyBorderWidget({super.key, required this.title, this.subTitle, required this.iconData, this.iconColor, this.onTap});
  final String title;
  final String? subTitle;
  final IconData iconData;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      splashColor: iconColor?.withValues(alpha: 0.1),
      leading: Icon(iconData, color: iconColor),
      title: Text(title),
      subtitle: subTitle != null ? Text(subTitle!) : null,
      titleTextStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
      subtitleTextStyle: Theme.of(context).textTheme.bodySmall?.apply(fontSizeFactor: 0.9),
      trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).hintColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).hintColor, width: 0.2)),
    );
  }
}
