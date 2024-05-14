import 'package:flutter/foundation.dart';

import '../../models/app_exception.dart';

class AppExceptionController extends ChangeNotifier {
  List<AppException> state = [];

  void onClear() {
    state = [];
    notifyListeners();
  }

  void onDelete(AppException item) {
    state.remove(item);
    notifyListeners();
  }
}
