import 'dart:convert';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';

final class Helper {
  static String? _infoDevice;

  /// String? or DateTime
  static String tryFormatDateTime(dynamic date) {
    DateTime? inputDate;
    if (date is String?) {
      if (date == null || date.isEmpty || date == 'null') return '';
      inputDate = DateTime.tryParse(date);
    } else if (date is DateTime) {
      inputDate = date;
    }

    if (inputDate == null) return date;
    String output = DateFormat.yMd(AppGlobals.context.locale.languageCode).add_Hms().format(inputDate);
    return output;
  }

  static String defaultFormatDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  /// [decimalRound] default = 7
  static String formatNumber(num number, [int? decimalRound]) {
    //create 7 '#'
    String format = '#';
    for (var i = 0; i < (decimalRound ?? 7) - 1; i++) {
      format += '#';
    }
    // '#,###.#######'
    return NumberFormat('#,###.$format', 'en_US').format(number);
  }

  //limitShowList
  static void limitShowList(List list, [int limit = 5]) => (list.length > limit) ? list.removeRange(limit, list.length) : null;

  static Color get randomColor => Colors.primaries[Random().nextInt(Colors.primaries.length)];
  //  Color get randomColorAccents => Colors.accents[Random().nextInt(Colors.accents.length)];
  static num randomNumber({num min = 0, required num max}) {
    if (max is double || min is double) {
      return min.toDouble() + Random().nextDouble() * (max.toDouble() - min.toDouble());
    }
    return min.toInt() + Random().nextInt(max.toInt() - min.toInt());
  }

  static Future<dynamic> readFileJson(String assets) async => jsonDecode(await rootBundle.loadString(assets));

  static bool containsToLowerCase(String? source, String? target) {
    if (source == null || target == null) return false;
    return source.toLowerCase().contains(target.toLowerCase());
  }

  static String generateIdFromDateTimeNow() => DateFormat('yyyyMMddHHmmssSSS').format(DateTime.now());

  static List<Map<String, dynamic>> convertToListMap(List<dynamic> list) =>
      List<Map<String, dynamic>>.from(list.map((e) => Map<String, dynamic>.from(e)));

  static Future<String> getInfoDevice() async {
    if (_infoDevice?.isEmpty ?? true) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (kIsWeb) {
        final info = (await deviceInfo.webBrowserInfo);
        _infoDevice = info.browserName.toString();
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            final info = (await deviceInfo.androidInfo);
            _infoDevice = '${info.manufacturer} - ${info.model} - ${info.version.incremental}';
            break;
          case TargetPlatform.iOS:
            final info = (await deviceInfo.iosInfo);
            _infoDevice = '${info.name} - ${info.systemVersion}';
            break;
          default:
            break;
        }
      }
      // deviceInfo!.data.map((key, value) {
      //           if (value is Enum) value = value.name;
      //           return MapEntry(key, value);
      //         }),
    }

    return _infoDevice ?? "";
  }

  static String formatJsonString(Object str) {
    final object = jsonDecode('$str');
    final prettyString = const JsonEncoder.withIndent('  ').convert(object);
    return prettyString;
  }

  static String toMessageError(dynamic errorMessage) {
    String message = '';
    if (errorMessage is Map) {
      if (errorMessage.containsKey('error') || errorMessage.containsKey('message')) {
        if (errorMessage['error'] is Map) {
          //cho nay` bat' loi~ OpenAI
          message = errorMessage['error']['message'];
        } else {
          message = (errorMessage['message'] ?? errorMessage['error']).toString();
        }
      } else {
        errorMessage.forEach((key, value) {
          if (value is List) {
            message += '${value.join('\n')}\n';
          } else {
            message += value.toString();
          }
        });
      }
    } else {
      message = errorMessage.toString();
    }
    return message;
  }
}
