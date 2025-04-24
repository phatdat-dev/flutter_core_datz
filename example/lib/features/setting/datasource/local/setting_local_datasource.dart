import 'package:flutter_core_datz/flutter_core_datz.dart';

import '../../../../app/storage_constants.dart';
import '../../../../core/base_datasource.dart';

class SettingLocalDatasource extends BaseLocalDataSource {
  FutureEitherAppException<bool> saveAvatarUrl(String url) async {
    final result = AppException().handleExceptionAsync(() async {
      return await sharedPrefs.setString(StorageConstants.avatarUrl, url);
    });
    return result;
  }

  FutureEitherAppException<String> getAvatarUrl() async {
    final result = AppException().handleException(() {
      final rawString = sharedPrefs.getString(StorageConstants.avatarUrl);
      return rawString ?? '';
    });
    return result;
  }
}
