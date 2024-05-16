import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';

import '../app/base_configs.dart';

// Loadding.show(); Loadding.dismiss();
class Loadding {
  static GlobalKey<LoaddingWidgetState> _key = GlobalKey<LoaddingWidgetState>();

  static final List<bool> _stacKLoadding = [];

  static void show() async {
    _stacKLoadding.add(true);
    if (_key.currentContext == null && _stacKLoadding.length == 1) {
      await showDialog(
        context: AppGlobals.context, // rootNavigatorKey MaterialApp
        barrierDismissible: true,
        builder: (context) => LoaddingWidget(key: _key),
      );
      _stacKLoadding.clear();
    }
  }

  static void dismiss() {
    if (_stacKLoadding.isNotEmpty) _stacKLoadding.removeLast();
    if (_stacKLoadding.isEmpty && _key.currentContext != null) {
      Navigator.of(_key.currentContext!, rootNavigator: true).pop();
      _key = GlobalKey<LoaddingWidgetState>();
    }
  }
}

class LoaddingWidget extends StatefulWidget {
  const LoaddingWidget({super.key});

  @override
  State<LoaddingWidget> createState() => LoaddingWidgetState();
}

class LoaddingWidgetState extends State<LoaddingWidget> {
  late final AssetImage imageLoadding;

  @override
  void initState() {
    imageLoadding = AssetImage(baseConfigs.appAssetsPath.loadding);
    super.initState();
  }

  @override
  void dispose() {
    imageLoadding.evict();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Dialog(
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
              child: Image(
                image: imageLoadding,
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
