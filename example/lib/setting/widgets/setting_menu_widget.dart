import 'package:flutter/material.dart';

class SettingMenuWidget extends StatelessWidget {
  const SettingMenuWidget({super.key, required this.title, this.subTitle, required this.iconData, this.iconColor, this.onTap, this.enabled = true});
  final String title;
  final String? subTitle;
  final IconData iconData;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: enabled ? onTap : null,
      tileColor: Theme.of(context).highlightColor.withValues(alpha: 0.1),
      splashColor: iconColor?.withValues(alpha: 0.15),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: iconColor?.withValues(alpha: 0.15) ?? Theme.of(context).highlightColor.withValues(alpha: 0.25),
        ),
        child: Icon(iconData, color: iconColor),
      ),
      title: Text(title),
      subtitle: subTitle != null ? Text(subTitle!) : null,
      titleTextStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: enabled ? null : Theme.of(context).highlightColor),
      subtitleTextStyle: Theme.of(context).textTheme.bodySmall?.apply(fontSizeFactor: 0.9),
      trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).highlightColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class ExpansionTitleSettingMenuWidget extends StatelessWidget {
  const ExpansionTitleSettingMenuWidget({
    super.key,
    required this.title,
    this.subTitle,
    required this.iconData,
    this.iconColor,
    required this.children,
  });
  final String title;
  final String? subTitle;
  final IconData iconData;
  final Color? iconColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: iconColor?.withValues(alpha: 0.15)),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: iconColor?.withValues(alpha: 0.15) ?? Theme.of(context).highlightColor.withValues(alpha: 0.25),
          ),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleSmall),
        subtitle: subTitle != null ? Text(subTitle!, style: Theme.of(context).textTheme.bodySmall?.apply(fontSizeFactor: 0.8)) : null,
        collapsedIconColor: Theme.of(context).highlightColor,
        collapsedBackgroundColor: Theme.of(context).highlightColor.withValues(alpha: 0.15),
        backgroundColor: Theme.of(context).highlightColor.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        children: children,
      ),
    );
  }
}
