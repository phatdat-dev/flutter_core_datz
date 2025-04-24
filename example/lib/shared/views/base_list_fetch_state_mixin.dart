import 'package:flutter/material.dart';

import '../../core/base_view.dart';
import '../../core/controller/base_fetch_controller.dart';

mixin BaseListFetchStateMixin<T extends StatefulWidget, C extends BaseFetchController> on State<T> implements RegisterBaseControllerStateMixin<T, C> {
  late final ScrollController scrollController;

  // @override
  // void initState() {
  //   // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //   //   scrollController.addListener(() => controller.onListenScrollToBottom(scrollController));
  //   // });
  //   super.initState();
  // }

  @override
  void dispose() {
    scrollController.removeListener(() => controller.onListenScrollToBottom(scrollController));
    super.dispose();
  }
}
