import 'package:flutter/material.dart';

import '../../../shared/widgets/circle_avatar_hoyolab_widget.dart';

class CircleAvatarOutlineEdit extends StatelessWidget {
  const CircleAvatarOutlineEdit({super.key, this.backgroundColor, this.radius = 30});
  final Color? backgroundColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatarHoyolabWidget(radius: radius),
        // CircleAvatarOutline(
        //   child: CircleAvatar(
        //     radius: radius,
        //     backgroundImage: HelperWidget.imageProviderFrom("assets/images/avatar.jpg"),
        //     backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
        //   ),
        // ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () => showAvatarSetDialog(context),
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                //neu dang hoat dong thi` them cai bo tron` nho? nho?
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: const Icon(Icons.camera_alt_outlined, size: 15),
            ),
          ),
        ),
      ],
    );
  }
}
