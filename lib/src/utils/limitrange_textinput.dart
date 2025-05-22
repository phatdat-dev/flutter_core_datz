import 'package:flutter/services.dart';

import '../../flutter_core_datz.dart';

/// ```dart
/// inputFormatters: (isInputNumber)
/// ? <TextInputFormatter>[
///     //only number
///     // FilteringTextInputFormatter.digitsOnly,
///     FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
///     LimitRangeTextInput(minRange: 0, maxRange: maxRangeNumber ?? double.infinity),
///   ]
/// : null,
/// ```
class LimitRangeTextInput extends TextInputFormatter {
  final double minRange;

  final double maxRange;
  final int? decimalRound;
  LimitRangeTextInput({
    required this.minRange,
    required this.maxRange,
    this.decimalRound,
  }) : assert(minRange <= maxRange);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    int count = 0;
    for (int i = 0; i < newValue.text.length; i++) {
      if (newValue.text[i] == '.') {
        count++;
      }
      if (count == 2) return oldValue;
    }

    //neu nhap dau' thap phan (.) giua~ chung` ma` phia' sau ko co' so' thi` tra? ve` dau' . con` nguyen vi tri' ko thay doi?
    final arrayS = newValue.text.split('.');

    if (arrayS.last.isEmpty) return newValue;
    //ep' kieu?, format so'

    var value = newValue.text.toDouble();
    if (value < minRange) return TextEditingValue(text: '$minRange');

    // return value > maxRange ? oldValue : newValue;
    if (value > maxRange) {
      final format = Helper.formatNumber(maxRange, decimalRound);
      return oldValue.copyWith(
        text: format,
        selection: TextSelection.collapsed(offset: format.length),
      );
    }
    String format;
    try {
      format = Helper.formatNumber(value, decimalRound);
    } catch (e) {
      format = '';
    }
    return newValue.copyWith(
      text: format,
      selection: TextSelection.collapsed(offset: format.length),
    );
  }
}
