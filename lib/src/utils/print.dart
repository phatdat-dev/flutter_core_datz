// ignore_for_file: avoid_print
//https://stackoverflow.com/questions/54018071/how-to-call-print-with-colorful-text-to-android-studio-console-in-flutter
import 'dart:developer';

typedef PrinttLog = void Function(Object? object);

class Printt {
  static void defaultt(Object? object) => log(StringPrintColor.defaultt(object));
  static void black(Object? object) => log(StringPrintColor.black(object));
  static void red(Object? object) => log(StringPrintColor.red(object));
  static void green(Object? object) => log(StringPrintColor.green(object));
  static void yellow(Object? object) => log(StringPrintColor.yellow(object));
  static void blue(Object? object) => log(StringPrintColor.blue(object));
  static void magenta(Object? object) => log(StringPrintColor.magenta(object));
  static void cyan(Object? object) => log(StringPrintColor.cyan(object));
  static void white(Object? object) => log(StringPrintColor.white(object));
  static void reset(Object? object) => log(StringPrintColor.reset(object));
}

class StringPrintColor {
  static String defaultt(Object? object) => '$object';
  static String black(Object? object) => '\x1B[30m$object\x1B[0m';
  static String red(Object? object) => '\x1B[31m$object\x1B[0m';
  static String green(Object? object) => '\x1B[32m$object\x1B[0m';
  static String yellow(Object? object) => '\x1B[33m$object\x1B[0m';
  static String blue(Object? object) => '\x1B[34m$object\x1B[0m';
  static String magenta(Object? object) => '\x1B[35m$object\x1B[0m';
  static String cyan(Object? object) => '\x1B[36m$object\x1B[0m';
  static String white(Object? object) => '\x1B[37m$object\x1B[0m';
  static String reset(Object? object) => '\x1B[38m$object\x1B[0m';
}
