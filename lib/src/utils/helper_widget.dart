import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:toastification/toastification.dart';

import '../../flutter_core_datz.dart';
import '../widgets/my_cached_network_image.dart';

final class HelperWidget {
  static void showToastError(String message) {
    final context = Globals.context;
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topCenter,
      title: const Text("Error !"),
      description: Text(message),
      showProgressBar: true,
      autoCloseDuration: const Duration(seconds: 5),
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),
      callbacks: ToastificationCallbacks(
        onTap: (toast) {
          const AppExceptionRoute().push(context);
          toastification.dismiss(toast);
        },
      ),
    );
  }

  //hight light occurrentces
  static List<TextSpan> highlightOccurrences(String text, String query) {
    final List<TextSpan> spans = [];
    final String lowercaseText = text.toLowerCase();
    final String lowercaseQuery = query.toLowerCase();

    int lastIndex = 0;
    int index = lowercaseText.indexOf(lowercaseQuery);

    while (index != -1) {
      spans.add(TextSpan(text: text.substring(lastIndex, index)));
      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      lastIndex = index + query.length;
      index = lowercaseText.indexOf(lowercaseQuery, lastIndex);
    }

    spans.add(TextSpan(text: text.substring(lastIndex, text.length)));

    return spans;
  }

  static ImageProvider imageProviderFrom(String imagePath) {
    final configs = GetIt.instance<BaseConfigs>();
    if (imagePath.isEmpty) return AssetImage(configs.assetsPath.imageError);
    if (imagePath.isURL || imagePath.contains('http')) {
      return CachedNetworkImageProvider(imagePath);
    } else if (imagePath.contains('assets')) {
      return AssetImage(imagePath) as ImageProvider;
    } else if (File(imagePath).existsSync()) {
      return FileImage(File(imagePath));
    }
    return AssetImage(configs.assetsPath.imageError);
  }

  static Widget imageWidget(
    String imagePath, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    if (imagePath.isVectorFileName) {
      return SvgPicture.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        colorFilter: color?.toColorFilter(),
      );
    }

    if (imagePath.isURL || imagePath.contains('http')) {
      return MyCachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit,
      );
    } else if (imagePath.contains('assets')) {
      return Image.asset(imagePath, width: width, height: height, fit: fit);
    } else if (File(imagePath).existsSync()) {
      return Image.file(File(imagePath), width: width, height: height, fit: fit);
    }
    return const SizedBox.shrink();
  }

  static Future<T?> showCustomAlertDialog<T>({
    required Widget child,
    List<Widget>? actions,
    BuildContext? context,
    double? width,
    double? height,
    bool defaultSize = true,
    bool barrierDismissible = true,
    EdgeInsets? insetPadding,
    Color? backgroundColor,
    EdgeInsets? iconPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? buttonPadding,
    EdgeInsets? actionsPadding,
    EdgeInsets? contentPadding,
  }) async {
    if (width != null && height != null) defaultSize = false;
    const EdgeInsets defaultInsetPadding = EdgeInsets.symmetric(
      horizontal: 40.0,
      vertical: 24.0,
    );
    return await showDialog<T>(
      context: context ?? Globals.context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        scrollable: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: insetPadding ?? defaultInsetPadding,
        iconPadding: iconPadding,
        titlePadding: titlePadding,
        buttonPadding: buttonPadding,
        actionsPadding: actionsPadding,
        contentPadding: contentPadding,
        content: SizedBox(
          width: defaultSize ? context.width * 0.5 : width,
          height: defaultSize ? context.height * 0.3 : height,
          child: child,
        ),
        actions: actions,
      ),
    );
  }

  static Future<T?> showSearchDropDown<T extends SearchDelegateQueryName>({
    required Iterable<T> data,
    BuildContext? context,
    String? hintText = 'Search...',
    T? currentSelected,
    BorderRadiusGeometry? borderRadius,
    String Function(int index, String queryName)? queryNameItemBuilder,
  }) async {
    final ValueNotifier<List<T>> search = ValueNotifier(data.toList());
    final txtController = TextEditingController();
    return await showDialog<T>(
      // showGeneralDialog
      context: context ?? Globals.context,
      builder: (context) {
        final size = context.mediaQuerySize;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(10)),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          scrollable: true,
          title: Container(
            height: 40,
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: txtController,
              onChanged: (value) => HelperReflect.search(
                listOrigin: data,
                listSearch: search,
                nameModel: 'queryName',
                keywordSearch: value,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: const Icon(Icons.search_rounded),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          content: SizedBox(
            width: size.width,
            height: size.height / 2,
            child: ValueListenableBuilder(
              valueListenable: search,
              builder: (context, searchValue, child) => ListView.builder(
                shrinkWrap: true,
                itemCount: searchValue.length,
                itemBuilder: (context, index) {
                  final isSelected = currentSelected == searchValue[index];
                  String queryName = searchValue[index].queryName;
                  queryName = queryNameItemBuilder?.call(index, queryName) ?? queryName;
                  return ListTile(
                    title: txtController.text.isEmpty
                        ? Text(
                            queryName,
                            style: isSelected ? const TextStyle(fontWeight: FontWeight.bold) : null,
                          )
                        : RichText(
                            text: TextSpan(
                              children: highlightOccurrences(
                                queryName,
                                txtController.text,
                              ),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                    onTap: () => Navigator.of(context).pop(searchValue[index]),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
