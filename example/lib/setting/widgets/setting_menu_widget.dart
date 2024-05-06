import 'package:flutter/material.dart';

class SettingMenuWidget extends StatelessWidget {
  const SettingMenuWidget({
    super.key,
    required this.title,
    this.subTitle,
    required this.iconData,
    this.iconColor,
    this.onTap,
    this.enabled = true,
  });
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
      tileColor: Theme.of(context).hintColor.withOpacity(0.05),
      splashColor: iconColor?.withOpacity(0.1),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: iconColor?.withOpacity(0.1) ?? Theme.of(context).hintColor.withOpacity(0.2),
        ),
        child: Icon(iconData, color: iconColor),
      ),
      title: Text(title),
      subtitle: subTitle != null ? Text(subTitle!) : null,
      titleTextStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: enabled ? null : Theme.of(context).hintColor),
      subtitleTextStyle: Theme.of(context).textTheme.bodySmall?.apply(fontSizeFactor: 0.9),
      trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).hintColor),
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
      data: Theme.of(context).copyWith(splashColor: iconColor?.withOpacity(0.1)),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: iconColor?.withOpacity(0.1) ?? Theme.of(context).hintColor.withOpacity(0.2),
          ),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleSmall),
        subtitle: subTitle != null ? Text(subTitle!, style: Theme.of(context).textTheme.bodySmall?.apply(fontSizeFactor: 0.8)) : null,
        collapsedIconColor: Theme.of(context).hintColor,
        collapsedBackgroundColor: Theme.of(context).hintColor.withOpacity(0.1),
        backgroundColor: Theme.of(context).hintColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        children: children,
      ),
    );
  }
}
