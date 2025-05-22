import 'package:flutter/material.dart';

class BorderContainerWidget extends StatelessWidget {
  final Color color;
  final String title;
  const BorderContainerWidget({
    super.key,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (title == '') {
      return const SizedBox();
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 5,
          right: 16.0,
          bottom: 5,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: 12),
          // overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
