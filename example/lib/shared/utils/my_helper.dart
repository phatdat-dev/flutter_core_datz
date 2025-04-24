import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:path_provider/path_provider.dart';

final class MyHelper {
  static Future<String> getDirectoryDownloadPath() async {
    return (await getApplicationCacheDirectory()).path;
  }

  static String indexQueryNameItemBuilder(int index, String queryName) => "${index + 1} - $queryName";

  static List<String> getDaysOfWeek([String? locale]) {
    // var days = DateFormat.EEEE().dateSymbols.STANDALONEWEEKDAYS;
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => index).map((value) => DateFormat.E(locale).format(firstDayOfWeek.add(Duration(days: value)))).toList();
  }

  static String generateVietQR({
    required String soTaiKhoan,
    required String nganHang,
    required String soTien,
    required String noiDung,
    String template = '',
    bool download = false,
  }) {
    // '',compact,qronly
    // final url = "https://qr.sepay.vn/img?acc=$soTaiKhoan&bank=$nganHang&amount=$soTien&des=$noiDung&template=$template&download=$download";
    // final url = "https://img.vietqr.io/image/$nganHang-$soTaiKhoan-qr_only.png?amount=$soTien&addInfo=$noiDung&accountName=$tenTaiKhoan";
    final code = "";

    final url = "https://api.vietqr.io/image/$nganHang-$soTaiKhoan-$code.jpg?amount=$soTien&addInfo=$noiDung";

    Printt.white(url);
    return url;
  }

  // 19.5 => 19:30
  static String convertDoubleToHour(double value) {
    // "${hour.toString().padLeft(2, "0")}:00",
    return "${value.toInt().toString().padLeft(2, "0")}:${(value % 1 * 60).toInt().toString().padLeft(2, "0")}";
  }

  static Duration calculateTimeDifference(String startTime, String endTime) {
    // Định dạng thời gian (giờ:phút)
    final DateFormat formatter = DateFormat("HH:mm");

    // Chuyển chuỗi thành DateTime
    DateTime start = formatter.parse(startTime);
    DateTime end = formatter.parse(endTime);

    // Tính khoảng cách thời gian
    Duration difference = end.difference(start);

    // Nếu thời gian kết thúc nhỏ hơn thời gian bắt đầu (qua ngày mới)
    if (difference.isNegative) {
      end = end.add(const Duration(days: 1));
      difference = end.difference(start);
    }

    return difference;
  }

  static String formatDurationToHHmm(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
