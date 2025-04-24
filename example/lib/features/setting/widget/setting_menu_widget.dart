import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';

abstract class _SettingMenuWidget extends StatelessWidget {
  final dynamic icon;
  final Color? iconColor;
  final bool addLeadingBorder;
  final double widthIcon;

  const _SettingMenuWidget({super.key, required this.icon, this.iconColor, this.addLeadingBorder = true, this.widthIcon = 30});

  Widget buildLeading(BuildContext context) {
    bool iconIsPath = (icon is String) && ((icon as String).isNotEmpty);
    Widget leading;
    if (icon is IconData) {
      leading = Icon(icon, color: iconColor);
    } else if (iconIsPath) {
      leading = HelperWidget.imageWidget(icon!, width: widthIcon, color: iconColor);
    } else {
      leading = SizedBox(width: widthIcon);
    }
    if (addLeadingBorder) {
      leading = Container(
        width: 40,
        height: 40,
        padding: iconIsPath ? const EdgeInsets.all(8) : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: iconColor?.withValues(alpha: 0.1) ?? Theme.of(context).highlightColor.withValues(alpha: 0.2),
        ),
        child: leading,
      );
    }
    return leading;
  }
}

class SettingMenuWidget extends _SettingMenuWidget {
  const SettingMenuWidget({
    super.key,
    required this.title,
    this.subTitle,
    super.icon,
    super.iconColor,
    this.onTap,
    this.enabled = true,
    super.addLeadingBorder = true,
    super.widthIcon = 30,
  });
  final String title;
  final String? subTitle;

  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: ListTile(
        onTap: enabled ? onTap : null,
        tileColor: Theme.of(context).highlightColor.withValues(alpha: 0.07),
        splashColor: iconColor?.withValues(alpha: 0.1),
        leading: buildLeading(context),
        title: Text(title.tr()),
        subtitle: subTitle != null ? Text(subTitle!.tr()) : null,
        titleTextStyle: Theme.of(context).textTheme.titleSmall,
        subtitleTextStyle: Theme.of(context).textTheme.bodySmall?.apply(fontSizeFactor: 0.9),
        trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).highlightColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class ExpansionTitleSettingMenuWidget extends _SettingMenuWidget {
  const ExpansionTitleSettingMenuWidget({
    super.key,
    required this.title,
    this.subTitle,
    required super.icon,
    super.iconColor,
    required this.children,
    super.addLeadingBorder = true,
    super.widthIcon = 30,
    this.childrenPadding,
    this.shape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
  });
  final String title;
  final String? subTitle;
  final List<Widget> children;
  final EdgeInsetsGeometry? childrenPadding;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: iconColor?.withValues(alpha: 0.1)),
      child: ExpansionTile(
        leading: buildLeading(context),
        title: Text(title.tr(), style: Theme.of(context).textTheme.titleSmall),
        subtitle: subTitle != null ? Text(subTitle!.tr(), style: Theme.of(context).textTheme.bodySmall?.apply(fontSizeFactor: 0.8)) : null,
        collapsedIconColor: Theme.of(context).highlightColor,
        collapsedBackgroundColor: Theme.of(context).highlightColor.withValues(alpha: 0.07),
        backgroundColor: Theme.of(context).highlightColor.withValues(alpha: 0.07),
        shape: shape,
        collapsedShape: shape,
        childrenPadding: childrenPadding,
        children: children,
      ),
    );
  }
}
