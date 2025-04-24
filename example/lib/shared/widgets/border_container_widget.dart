import 'package:flutter/material.dart';

class BorderContainerWidget extends StatelessWidget {
  final Color color;
  final String title;
  final TextStyle? style;
  final bool filled;
  final EdgeInsetsGeometry padding;
  const BorderContainerWidget({
    super.key,
    required this.color,
    required this.title,
    this.style,
    this.filled = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
  });

  @override
  Widget build(BuildContext context) {
    if (title == '') {
      return const SizedBox();
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: padding,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style:
              style?.copyWith(color: color) ??
              TextStyle(
                color: filled ? Theme.of(context).colorScheme.surface : color,
                fontSize: 12,
              ),
          // overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
