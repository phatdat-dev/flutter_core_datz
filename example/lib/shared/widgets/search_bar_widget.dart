// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';

class SearchBarWidget extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTapTextField;
  final bool readOnly;
  TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefixIcon;
  final ({Icon icon, GestureTapCallback onTap})? suffixIconButton;
  final bool filled;
  final Color? fillColor;

  SearchBarWidget({
    super.key,
    this.hintText,
    this.onChanged,
    this.onTapTextField,
    this.controller,
    this.readOnly = false,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIconButton,
    this.filled = false,
    this.fillColor,
  }) {
    controller = controller ?? TextEditingController();
  }
  factory SearchBarWidget.card({
    Key? key,
    String? hintText,
    ValueChanged<String>? onChanged,
    VoidCallback? onTapTextField,
    TextEditingController? controller,
    bool readOnly = false,
    Color? fillColor,
    double? elevation,
    ValueChanged<String>? onSubmitted,
    Widget? prefixIcon,
    ({Icon icon, GestureTapCallback onTap})? suffixIconButton,
  }) => _SearchBarWithCardWidget(
    key: key,
    hintText: hintText,
    onChanged: onChanged,
    onTapTextField: onTapTextField,
    controller: controller,
    readOnly: readOnly,
    fillColor: fillColor,
    elevation: elevation,
    onSubmitted: onSubmitted,
    prefixIcon: prefixIcon,
    suffixIconButton: suffixIconButton,
  );

  static final Debouncer debouncer = Debouncer(delay: const Duration(milliseconds: 200));
  static final BorderRadius defaultBorderRadius = BorderRadius.circular(25);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        filled: filled,
        fillColor: fillColor,
        //
        border: OutlineInputBorder(borderRadius: defaultBorderRadius),
        enabledBorder: OutlineInputBorder(borderRadius: defaultBorderRadius, borderSide: BorderSide(color: Theme.of(context).hintColor, width: 0.1)),
        focusedBorder: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 0.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: BorderSide(color: Theme.of(context).hintColor, width: 0.05),
        ),
        //
        hintText: hintText ?? "${"Search".tr()}...",
        hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.7), fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        prefixIcon: prefixIcon ?? Icon(Icons.search, color: Theme.of(context).primaryColor),
        suffixIcon: buildSuffixIcon(),
      ),
      onChanged: (value) {
        if (onChanged != null) debouncer(() async => onChanged!(value));
      },
      onTap: onTapTextField,
    );
  }

  Widget buildSuffixIcon() {
    return ValueListenableBuilder(
      valueListenable: controller!,
      builder:
          (context, value, child) => InkWell(
            onTap:
                (controller!.text.isEmpty)
                    ? null
                    : () {
                      if (suffixIconButton != null) {
                        suffixIconButton?.onTap();
                      } else {
                        controller!.clear();
                        onChanged != null ? onChanged!('') : null;
                      }
                    },
            borderRadius: defaultBorderRadius,
            child: (suffixIconButton?.icon ?? const Icon(Icons.close)).copyWith(
              color: (controller!.text.isEmpty) ? Theme.of(context).disabledColor : null,
            ),
          ),
    );
  }
}

class _SearchBarWithCardWidget extends SearchBarWidget {
  final double? elevation;

  _SearchBarWithCardWidget({
    super.key,
    super.hintText,
    super.onChanged,
    super.onTapTextField,
    super.controller,
    super.readOnly = false,
    super.fillColor,
    this.elevation,
    super.onSubmitted,
    super.prefixIcon,
    super.suffixIconButton,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: SearchBarWidget.defaultBorderRadius),
      elevation: elevation,
      color: fillColor,
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          // filled: true,
          border: OutlineInputBorder(
            borderRadius: SearchBarWidget.defaultBorderRadius,
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
          hintText: hintText ?? "${"Search".tr()}...",
          hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.7), fontSize: 16),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          prefixIcon: prefixIcon ?? Icon(Icons.search, color: Theme.of(context).primaryColor),
          suffixIcon: Material(elevation: 0.5, borderRadius: SearchBarWidget.defaultBorderRadius, child: buildSuffixIcon()),
        ),
        onChanged: (value) {
          if (onChanged != null) SearchBarWidget.debouncer(() async => onChanged!(value));
        },
        onTap: onTapTextField,
      ),
    );
  }
}
