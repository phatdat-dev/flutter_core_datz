import 'package:flutter/material.dart';

import '../../core/base_view.dart';
import '../../core/controller/base_fetch_controller.dart';
import '../utils/scroll_debouncer.dart';

abstract class BaseListFetchState<T extends StatefulWidget, C extends BaseFetchController> extends State<T>
    with _BaseListFetchStateMixin<T, C>, IGetBaseControllerStateMixin<T, C> {}

mixin _BaseListFetchStateMixin<T extends StatefulWidget, C extends BaseFetchController> on State<T> implements IGetBaseControllerStateMixin<T, C> {
  late final ScrollController scrollController;
  late final ScrollDebouncer _scrollDebouncer;
  bool _isScrollListenerAttached = false;

  @override
  void dispose() {
    if (_isScrollListenerAttached) {
      scrollController.removeListener(_scrollListener);
    }
    _scrollDebouncer.dispose();
    controller.onDispose();
    super.dispose();
  }

  @override
  void initState() {
    scrollController = createScrollController();
    _scrollDebouncer = ScrollDebouncer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attachScrollListener();
    });
    super.initState();
  }

  void _attachScrollListener() {
    if (!_isScrollListenerAttached) {
      scrollController.addListener(_scrollListener);
      _isScrollListenerAttached = true;
    }
  }

  void _scrollListener() {
    if (scrollController.hasClients) {
      _scrollDebouncer(() {
        controller.onListenScrollToBottom(scrollController);
      });
    }
  }

  ScrollController createScrollController() => ScrollController();
}
