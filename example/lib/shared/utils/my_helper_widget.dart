import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:toastification/toastification.dart';

import '../../app/app_constants.dart';

final class MyHelperWidget {
  static void showToastSuccess(String message, {ToastificationCallbacks callbacks = const ToastificationCallbacks()}) {
    final context = AppGlobals.context;
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topCenter,
      title: const Text("Thành công !"),
      description: Text(message),
      showProgressBar: true,
      autoCloseDuration: const Duration(seconds: 5),
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.onHover),
      callbacks: callbacks,
    );
  }

  static void showToastWarning(String message) {
    final context = AppGlobals.context;
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topCenter,
      title: const Text("!!!"),
      description: Text(message),
      showProgressBar: true,
      autoCloseDuration: const Duration(seconds: 5),
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.onHover),
    );
  }

  static Widget prefixIcon(BuildContext context, dynamic prefixIcon, {double? size}) {
    if (prefixIcon is String) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: HelperWidget.imageWidget(prefixIcon, color: Theme.of(context).unselectedWidgetColor, width: size, height: size),
      );
    } else if (prefixIcon is IconData) {
      return Icon(prefixIcon, color: Theme.of(context).unselectedWidgetColor);
    } else {
      return prefixIcon;
    }
  }

  static EdgeInsetsGeometry bottomPaddingIOS({double horizontal = AppConstants.paddingContent}) =>
      Platform.isIOS
          ? EdgeInsets.only(bottom: kToolbarHeight / 3, left: horizontal, right: horizontal, top: 5)
          : EdgeInsets.symmetric(horizontal: horizontal);

  static BorderSide borderSide(BuildContext context) => Theme.of(context).inputDecorationTheme.enabledBorder?.borderSide ?? BorderSide.none;

  static ButtonStyle? greyButtonStyle(BuildContext context) {
    return Theme.of(context).filledButtonTheme.style?.copyWith(
      backgroundColor: WidgetStatePropertyAll(Theme.of(context).hintColor.withValues(alpha: 0.1)),
      foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onSurface),
      side: WidgetStatePropertyAll(MyHelperWidget.borderSide(context)),
    );
  }

  static Future<void> showCustomBottomSheet({required BuildContext context, required ScrollableWidgetBuilder builder}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      builder: (context) {
        return DraggableScrollableSheet(expand: false, minChildSize: 0.3, maxChildSize: 0.8, builder: builder);
      },
    );
  }

  // clone from flutter_core_datz
  static Future<T?> showSearchDropDownWithCustomCallBack<T extends SearchDelegateQueryName>({
    required ValueNotifier<Iterable<T>> data,
    required Function(Widget callBack) builder,
    BuildContext? context,
    String? hintText = 'Search...',
    T? currentSelected,
    BorderRadiusGeometry? borderRadius,
    String Function(int index, String queryName)? queryNameItemBuilder,
  }) async {
    final txtController = TextEditingController();
    return await showDialog<T>(
      // showGeneralDialog
      context: context ?? AppGlobals.context,
      builder: (context) {
        final size = context.mediaQuerySize;
        return ValueListenableBuilder(
          valueListenable: data,
          builder: (context, dataValue, child) {
            final ValueNotifier<List<T>> search = ValueNotifier(dataValue.toList());
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: borderRadius ?? AppConstants.borderRadius),
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              scrollable: true,
              content: builder.call(
                SizedBox(
                  width: size.width,
                  height: size.height / 2,
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        margin: const EdgeInsets.all(10),
                        child: TextField(
                          controller: txtController,
                          onChanged:
                              (value) =>
                                  HelperReflect.search(listOrigin: dataValue, listSearch: search, nameModel: 'queryName', keywordSearch: value),
                          decoration: InputDecoration(
                            hintText: hintText,
                            prefixIcon: const Icon(Icons.search_rounded),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: search,
                          builder:
                              (context, searchValue, child) => ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchValue.length,
                                itemBuilder: (context, index) {
                                  final isSelected = currentSelected == searchValue[index];

                                  String queryName = searchValue[index].queryName;
                                  queryName = queryNameItemBuilder?.call(index, queryName) ?? queryName;
                                  return ListTile(
                                    title:
                                        txtController.text.isEmpty
                                            ? Text(queryName, style: isSelected ? const TextStyle(fontWeight: FontWeight.bold) : null)
                                            : RichText(
                                              text: TextSpan(
                                                children: HelperWidget.highlightOccurrences(queryName, txtController.text),
                                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                              ),
                                            ),
                                    onTap: () => Navigator.of(context).pop(searchValue[index]),
                                  );
                                },
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
