import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({
    super.key,
    required this.title,
    this.path,
    this.data,
    this.builder,
  });

  /// Screen Title
  final String title;

  /// URL String or Asset Path
  final String? path;

  /// HTML Content Data
  final String? data;
  final Widget Function(BuildContext context, Widget inAppWebViewWidget)?
  builder;

  @override
  Widget build(BuildContext context) {
    assert(
      path.isNotNullAndEmpty || data.isNotNullAndEmpty,
      'Either path or data must be provided',
    );
    final Widget child;
    if (data.isNotNullAndEmpty) {
      child = InAppWebView(initialData: InAppWebViewInitialData(data: data!));
    } else if (path != null && path!.startsWith('assets/')) {
      child = InAppWebView(initialFile: path);
    } else {
      child = InAppWebView(initialUrlRequest: URLRequest(url: WebUri(path!)));
    }
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: false),
      body: builder != null ? builder!(context, child) : child,
    );
  }
}
