import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormBuilderTextFieldPasswordWidget extends StatefulWidget {
  const FormBuilderTextFieldPasswordWidget({
    super.key,
    this.name = "password",
    this.labelText = "Password",
    this.validators,
    this.initialValue,
    this.isNumber = false,
  });
  final String name;
  final String labelText;
  final String? initialValue;
  final bool isNumber;

  /// if is null, default add [FormBuilderValidators.required()]
  final List<FormFieldValidator>? validators;

  @override
  State<FormBuilderTextFieldPasswordWidget> createState() => _FormBuilderTextFieldPasswordWidgetState();
}

class _FormBuilderTextFieldPasswordWidgetState extends State<FormBuilderTextFieldPasswordWidget> {
  bool _isVisiblePassword = true;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      enableSuggestions: true,
      name: widget.name,
      initialValue: widget.initialValue,
      obscureText: _isVisiblePassword,
      keyboardType: widget.isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline, color: context.theme.unselectedWidgetColor),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _isVisiblePassword = !_isVisiblePassword),
          icon: Icon(_isVisiblePassword ? Icons.visibility : Icons.visibility_off, size: 24.0, color: context.theme.unselectedWidgetColor),
        ),
        labelText: widget.labelText.tr(),
      ),
      validator: FormBuilderValidators.compose([if (widget.validators != null) ...widget.validators! else FormBuilderValidators.required()]),
    );
  }
}
