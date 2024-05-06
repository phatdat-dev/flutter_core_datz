// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../app/app_globals.dart';
import '../../app/app_storage_constants.dart';
import '../../datasource/local/storage_service.dart';

final appTranslationController = AppTranslationController();

final class AppTranslationController {
  final _sharedPrefs = GetIt.instance.get<StorageService>().sharedPreferences!;

  // fallbackLocale là locale default nếu locale được set không nằm trong những Locale support
  final fallbackLocale = const Locale('en', 'US');
  static const startLocale = Locale('vi', 'VN');
  // các Locale được support
  final locales = [
    const Locale('en', 'US'),
    const Locale('vi', 'VN'),
    const Locale('ja', 'JP'),
  ];

  // function change language
  void changeLocale(Locale localeee) {
    AppGlobals.context.setLocale(localeee);
    _sharedPrefs.setString(AppStorageConstants.langCode, localeee.languageCode);
  }

  Future<Locale> getLocaleFromLanguage() async {
    final langCode = _sharedPrefs.get(AppStorageConstants.langCode);
    final context = AppGlobals.context;

    if (langCode == null) return context.deviceLocale;

    for (int i = 0; i < locales.length; i++) {
      if (langCode == locales[i].languageCode) return locales[i];
    }

    return context.deviceLocale;
  }

  static Future<void> initLocale() async {
    final String name = (startLocale.countryCode?.isEmpty ?? true) ? startLocale.languageCode : startLocale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    Intl.defaultLocale = localeName;
    initializeDateFormatting(); // fix intl date format
  }
}
