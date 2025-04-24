import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final double? width, height;
  final double left, right, top, bottom;

  const Skeleton({
    super.key,
    this.height,
    this.width,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(width: width, height: height, color: Colors.grey),
      ),
    );
  }
}
