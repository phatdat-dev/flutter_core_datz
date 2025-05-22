import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../app/base_configs.dart';

class MyCachedNetworkImage extends StatelessWidget {
  const MyCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
  });
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    final configs = GetIt.instance<BaseConfigs>();
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorWidget: (context, error, stackTrace) =>
          const Icon(Icons.image, color: Colors.grey),
      placeholder: (context, url) => Image.asset(configs.assetsPath.imageError),
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 180),
    );
  }
}
