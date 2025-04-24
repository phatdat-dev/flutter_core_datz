import 'package:flutter/material.dart';
import 'circle_avatar_hoyolab_widget.dart';


class CircleAvatarOutline extends StatelessWidget {
  const CircleAvatarOutline({
    super.key,
    this.radius = 25,
    this.child,
    this.borderColor,
  });
  final double radius;
  final Widget? child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: child ?? CircleAvatarHoyolabWidget(radius: radius),
    );
  }
}
