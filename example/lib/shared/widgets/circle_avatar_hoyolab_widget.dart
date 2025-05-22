import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../features/setting/controller/setting_controller.dart';
import '../../generated/assets.gen.dart';
import '../utils/my_helper_api.dart';
import 'circle_avatar_outline.dart';

String get _getAssetsLogo => Assets.images.logo.logo.keyName;

class CircleAvatarHoyolabWidget extends StatefulWidget {
  const CircleAvatarHoyolabWidget({
    super.key,
    this.radius = 25,
    this.backgroundColor,
  });
  final double radius;
  final Color? backgroundColor;

  @override
  State<CircleAvatarHoyolabWidget> createState() => _CircleAvatarHoyolabWidgetState();
}

class _CircleAvatarHoyolabWidgetState extends State<CircleAvatarHoyolabWidget> with AutomaticKeepAliveClientMixin {
  late final ValueNotifier<Map<String, dynamic>?> avatarSet;
  List? listImage;
  int? randomIndex;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    avatarSet = MyHelperApi.instance.avatarSet;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Hero(
      tag: 'avatar',
      child: CircleAvatar(
        backgroundColor: widget.backgroundColor ?? Colors.transparent,
        radius: widget.radius,
        child: ClipOval(
          child: ValueListenableBuilder(
            valueListenable: avatarSet,
            builder: (context, value, child) {
              if (value != null) {
                listImage ??= (value['data']['list'] as List)
                    // .where((e) => e['name'] == '原神')
                    .expand((e) => e['list'])
                    .toList();
                randomIndex ??= Random().nextInt(listImage!.length);
                //
                final settingController = GetIt.instance<SettingController>();
                if (settingController.avatarUrl.value.isEmpty) settingController.avatarUrl.value = listImage![randomIndex!]['icon'];

                return ValueListenableBuilder(
                  valueListenable: settingController.avatarUrl,
                  builder: (context, value, child) => FadeInImage.assetNetwork(
                    placeholder: _getAssetsLogo,
                    image: value,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 200),
                    fadeOutDuration: const Duration(milliseconds: 180),
                  ),
                );

                // return Image.network(
                //   listImage[Random().nextInt(listImage.length)]["icon"],
                //   fit: BoxFit.cover,
                //   loadingBuilder: (context, child, loadingProgress) {
                //     if (loadingProgress == null) return child;
                //     return Center(
                //       child: CircularProgressIndicator(
                //         value: loadingProgress.expectedTotalBytes != null
                //             ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                //             : null,
                //       ),
                //     );
                //   },
                // );
              }
              return Image.asset(_getAssetsLogo, fit: BoxFit.cover);
            },
          ),
        ),
      ),
    );
  }
}

void showAvatarSetDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final size = MediaQuery.sizeOf(context);
      final selectedAvatar = ValueNotifier('');
      const double radius = 30.0;
      return AlertDialog(
        title: const Text('Avatar Set'),
        // scrollable: true,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        titlePadding: const EdgeInsets.only(left: 10, top: 5),
        content: SizedBox(
          width: size.width * 0.9,
          height: size.height * 0.5,
          child: ValueListenableBuilder(
            valueListenable: MyHelperApi.instance.avatarSet,
            builder: (context, value, child) {
              if (value != null) {
                final listMapImage = (value['data']['list'] as List);
                final settingController = GetIt.instance<SettingController>();
                selectedAvatar.value = settingController.avatarUrl.value;
                return ListView.builder(
                  itemCount: listMapImage.length,
                  itemBuilder: (context, index) {
                    final e = listMapImage[index];
                    return Column(
                      children: [
                        Text(
                          "${e['game_name']} (${(e['list'] as List).length})",
                        ),
                        ValueListenableBuilder(
                          valueListenable: selectedAvatar,
                          builder: (context, value, child) => Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5,
                            runSpacing: 5,
                            children: (e['list'] as List).map<Widget>((e) {
                              Widget buildAvatar(double radius) => GestureDetector(
                                onTap: () => selectedAvatar.value = e['icon'],
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: radius,
                                  child: ClipOval(
                                    child: FadeInImage.assetNetwork(
                                      placeholder: _getAssetsLogo,
                                      image: e['icon'],
                                      fit: BoxFit.cover,
                                      fadeInDuration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      fadeOutDuration: const Duration(
                                        milliseconds: 180,
                                      ),
                                    ),
                                  ),
                                ),
                              );

                              final bool isSelected = value == e['icon'];

                              Widget child = buildAvatar(radius);

                              if (isSelected) {
                                child = CircleAvatarOutline(
                                  child: buildAvatar(radius + 10),
                                );
                              }

                              return AnimatedSize(
                                alignment: Alignment.center,
                                duration: const Duration(milliseconds: 200),
                                child: child,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              GetIt.instance<SettingController>().changeAvatarUrl(
                selectedAvatar.value,
              );
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
