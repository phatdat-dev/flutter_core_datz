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

  const CheckRadioCircleWidget({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.child,
  });

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
