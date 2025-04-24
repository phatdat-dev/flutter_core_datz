import 'package:flutter/material.dart';

class CheckRadioListTileWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final Widget title;
  final ValueChanged<T?> onChanged;
  final Widget? leading;
  final Widget? subtitle;
  final bool isThreeLine;

  const CheckRadioListTileWidget({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.leading,
    this.subtitle,
    this.isThreeLine = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return ListTile(
      onTap: () => onChanged(value),
      leading: leading,
      title: title,
      subtitle: subtitle,
      isThreeLine: isThreeLine,
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
    );
  }
}

// check Radio Circle
class CheckRadioCircleWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final Widget child;
  final ValueChanged<T?> onChanged;

  const CheckRadioCircleWidget({super.key, required this.value, required this.groupValue, required this.onChanged, required this.child});

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? Colors.blue : Colors.transparent),
          // color: isSelected ? Colors.blue : Colors.transparent,
        ),
        child: child,
      ),
    );
  }
}

// RadioListTitleWidget - Custom a Child for leading choose Answer (A, B, C, D)
class CircleRadioListTitleWidget<T> extends CheckRadioListTileWidget<T> {
  const CircleRadioListTitleWidget({
    super.key,
    required super.value,
    required super.groupValue,
    required super.onChanged,
    required super.title,
    required super.leading,
    super.subtitle,
    super.isThreeLine = false,
    this.contentPadding,
    this.circlePadding = 5,
    this.circleMargin = 5,
    this.circleColor = Colors.blue,
  });
  final EdgeInsetsGeometry? contentPadding;
  final double circlePadding;
  final double circleMargin;
  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return ListTile(
      contentPadding: contentPadding,
      minTileHeight: 0,
      onTap: () => onChanged(value),
      leading: Container(
        padding: EdgeInsets.all(circlePadding),
        margin: EdgeInsets.all(circleMargin),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? circleColor : Colors.transparent, width: 2)),
        child: leading,
      ),
      title: title,
      subtitle: subtitle,
      isThreeLine: isThreeLine,
    );
  }
}
