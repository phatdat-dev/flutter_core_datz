// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../app/app_globals.dart';
import '../../app/app_storage_constants.dart';
import '../../datasource/local/storage_service.dart';

final class TranslationController {
  // fallbackLocale là locale default nếu locale được set không nằm trong những Locale support
  final Locale fallbackLocale;
  final Locale startLocale;
  // các Locale được support
  final List<Locale> locales;
  TranslationController({
    this.fallbackLocale = const Locale('en', 'US'),
    this.startLocale = const Locale('vi', 'VN'),
    this.locales = const [
      Locale('en', 'US'),
      Locale('vi', 'VN'),
      Locale('ja', 'JP'),
    ],
  });

  final _sharedPrefs = GetIt.instance.get<StorageService>().sharedPreferences!;

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

  Future<void> init() async {
    final String name = (startLocale.countryCode?.isEmpty ?? true) ? startLocale.languageCode : startLocale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    Intl.defaultLocale = localeName;
    initializeDateFormatting(); // fix intl date format
  }
}
