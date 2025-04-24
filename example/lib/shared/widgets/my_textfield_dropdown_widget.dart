import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../core/controller/selected_search_controller.dart';
import '../utils/my_helper_widget.dart';
import 'search_anchor_bar_widget.dart';

class MyTextFieldDropdownWidget<T extends SearchDelegateQueryName> extends StatelessWidget {
  MyTextFieldDropdownWidget({
    super.key,
    required this.fieldName,
    this.prefixIcon,
    this.labelText,
    this.textStyle,
    required this.formKey,
    required this.listData,
    this.onChanged,
    this.enabled = true,
    this.initialValue,
    this.validators,
    this.builderDialog,
    this.currentSelectedTextBuilder,
  }) {
    // nếu có builderDialog thì listData phải là ValueNotifier<Iterable<T>>
    assert(listData is ValueNotifier<Iterable<T>> || listData is Iterable<T>);
    if (builderDialog != null) {
      assert(listData is ValueNotifier<Iterable<T>>);
    }
  }
  final String fieldName;

  /// String || IconData || Widget
  final dynamic prefixIcon;
  final String? labelText;
  final TextStyle? textStyle;
  final GlobalKey<FormBuilderState> formKey;
  final dynamic listData; // ValueNotifier<Iterable<T>> || Iterable<T>
  final ValueChanged<T>? onChanged;
  final bool enabled;
  final T? initialValue;
  final List<FormFieldValidator>? validators;
  final Function(Widget callBackWidget)? builderDialog;
  final String Function(T? currentSelected)? currentSelectedTextBuilder;

  factory MyTextFieldDropdownWidget.bar({
    Key? key,
    required String fieldName,
    dynamic prefixIcon,
    String? labelText,
    TextStyle? textStyle,
    required GlobalKey<FormBuilderState> formKey,
    required dynamic listData,
    ValueChanged<T>? onChanged,
    bool enabled = true,
    T? initialValue,
    List<FormFieldValidator>? validators,
    Iterable<Widget>? viewTrailing,
    SelectedSearchController<T>? controller,
  }) => _MyTextFieldDropdownSearchBarWidget<T>(
    key: key,
    fieldName: fieldName,
    prefixIcon: prefixIcon,
    labelText: labelText,
    textStyle: textStyle,
    formKey: formKey,
    listData: listData,
    onChanged: onChanged,
    enabled: enabled,
    initialValue: initialValue,
    validators: validators,
    viewTrailing: viewTrailing,
    controller: controller,
  );

  T? _getInitValue() {
    final fieldd = formKey.currentState?.fields[fieldName];
    T? initialValue;

    void setDefault() {
      initialValue =
          (listData is ValueNotifier<Iterable<T>>)
              ? (listData as ValueNotifier<Iterable<T>>).value.firstOrNull
              : (listData as Iterable<T>).firstOrNull;
      fieldd?.setValue(initialValue);
    }

    if (fieldd != null) {
      // nếu đã được rebuild trước đó nhưng value == null, thì set value = firstOrNull
      if (fieldd.value == null) {
        setDefault();
        // nếu field đã set thì ko cần
      } else {
        initialValue = fieldd.value;
      }
    } else {
      setDefault();
    }
    return initialValue;
  }

  String indexQueryNameItemBuilder(int index, String queryName) => "${index + 1} - $queryName";

  @override
  Widget build(BuildContext context) {
    T? initialValue = this.initialValue ?? _getInitValue();
    return FormBuilderField<T>(
      name: fieldName,
      initialValue: initialValue,
      enabled: enabled,
      builder: (field) {
        final currentSelected = field.value ?? initialValue;
        if (field.value == null) {
          // ignore: invalid_use_of_protected_member
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) => field.setValue(currentSelected));
        }
        return InkWell(
          onTap:
              enabled
                  ? () async {
                    T? value;
                    if (builderDialog != null) {
                      value = await MyHelperWidget.showSearchDropDownWithCustomCallBack<T>(
                        data: listData,
                        builder: builderDialog!,
                        // context: context,
                        currentSelected: currentSelected,
                        queryNameItemBuilder: indexQueryNameItemBuilder,
                      );
                    } else {
                      value = await HelperWidget.showSearchDropDown<T>(
                        data: listData,
                        // context: context,
                        currentSelected: currentSelected,
                        queryNameItemBuilder: indexQueryNameItemBuilder,
                      );
                    }
                    if (value != null) {
                      field.didChange(value);
                      onChanged?.call(value);
                    }
                  }
                  : null,
          child: InputDecorator(
            decoration: InputDecoration(
              prefixIcon: getPrefixIcon(prefixIcon, context),
              suffixIcon: buildSuffixIcon(context),
              labelText: labelText?.tr(),
              errorText: field.errorText,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                currentSelectedTextBuilder?.call(currentSelected) ?? currentSelected?.queryName ?? "",
                style: textStyle ?? (enabled ? null : TextStyle(color: Theme.of(context).disabledColor)),
              ),
            ),
          ),
        );
      },
      validator: validators != null ? FormBuilderValidators.compose(validators!) : null,
    );
  }

  Widget buildSuffixIcon(BuildContext context) =>
      Icon(Icons.keyboard_arrow_down_outlined, color: (enabled ? Theme.of(context).unselectedWidgetColor : Theme.of(context).disabledColor));
}

// ignore: must_be_immutable
class _MyTextFieldDropdownSearchBarWidget<T extends SearchDelegateQueryName> extends MyTextFieldDropdownWidget<T> {
  _MyTextFieldDropdownSearchBarWidget({
    super.key,
    required super.fieldName,
    super.prefixIcon,
    super.labelText,
    super.textStyle,
    required super.formKey,
    required super.listData,
    super.onChanged,
    super.enabled = true,
    super.initialValue,
    super.validators,
    this.viewTrailing,
    this.controller,
  });
  final Iterable<Widget>? viewTrailing;
  SelectedSearchController<T>? controller;

  @override
  Widget build(BuildContext context) {
    T? initialValue = this.initialValue ?? _getInitValue();
    controller ??= SelectedSearchController<T>();
    controller!.listData =
        (listData is ValueNotifier<Iterable<T>>) ? (listData as ValueNotifier<Iterable<T>>).value.toList() : (listData as Iterable<T>).toList();

    return FormBuilderField(
      name: fieldName,
      initialValue: initialValue,
      enabled: enabled,
      builder: (field) {
        final currentSelected = field.value ?? initialValue;
        if (field.value == null) {
          // ignore: invalid_use_of_protected_member
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) => field.setValue(currentSelected));
        }
        controller!
          ..onSelectionChanged = (value) {
            field.didChange(value);
            onChanged?.call(value);
          }
          ..selectedItem = currentSelected;
        Widget child = buildSearchBar(context, controller!);
        if (field.hasError) {
          child = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              child,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(field.errorText!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            ],
          );
        }

        return SizedBox(height: 48, child: enabled ? child : IgnorePointer(child: Opacity(opacity: 0.5, child: child)));
      },
      validator: validators != null ? FormBuilderValidators.compose(validators!) : null,
    );
  }

  Widget buildSearchBar(BuildContext context, SelectedSearchController<T> searchController) => SearchAnchorBarWidget(
    searchController: searchController,
    barLeading: getPrefixIcon(prefixIcon, context),
    barTrailing: [buildSuffixIcon(context)],
    barHintText: labelText?.tr(),
    viewTrailing: viewTrailing,
  );
}

Widget? getPrefixIcon(dynamic icon, BuildContext context, [double padding = 12]) {
  if (icon is IconData) {
    return Icon(icon, color: context.theme.unselectedWidgetColor);
  } else if (icon is String) {
    return Container(
      width: 1,
      height: 1,
      padding: EdgeInsets.all(padding),
      child: HelperWidget.imageWidget(icon, color: context.theme.unselectedWidgetColor),
    );
  } else if (icon is Widget) {
    return icon;
  }
  return null;
}
