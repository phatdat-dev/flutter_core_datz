import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../flutter_core_datz.dart';

// Loadding.show(); Loadding.dismiss();
class Loadding {
  static OverlayEntry? _overlayEntry;

  static void show() async {
    if (_overlayEntry != null) return;
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => dismiss(),
        child: Container(
          color: DialogTheme.of(context).barrierColor ?? Theme.of(context).dialogTheme.barrierColor ?? Colors.black54,
          child: const LoaddingWidget(),
        ),
      ),
    );
    Overlay.of(Globals.context).insert(_overlayEntry!);
  }

  static void dismiss() {
    if (_overlayEntry == null) return;
    _overlayEntry!.remove();
    _overlayEntry = null;
  }
}

class LoaddingWidget extends StatefulWidget {
  const LoaddingWidget({super.key});

  @override
  State<LoaddingWidget> createState() => LoaddingWidgetState();
}

class LoaddingWidgetState extends State<LoaddingWidget> {
  final configs = GetIt.instance<BaseConfigs>();
  late final AssetImage imageLoadding;

  @override
  void initState() {
    imageLoadding = AssetImage(configs.assetsPath.loadding);
    super.initState();
  }

  @override
  void dispose() {
    imageLoadding.evict();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(child: configs.loaddingWidget.call(imageLoadding));
}

class DefaultLoaddingWidget extends StatelessWidget {
  final AssetImage imageLoadding;

  const DefaultLoaddingWidget(this.imageLoadding, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: ClipOval(
            child: Image(image: imageLoadding, width: 200, height: 200),
          ),
        ),
      ),
    );
  }
}
