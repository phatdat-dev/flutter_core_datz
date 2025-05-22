import 'dart:convert';

import 'package:flutter_core_datz/flutter_core_datz.dart';

import '../../../../../app/storage_constants.dart';
import '../../../../../core/base_datasource.dart';
import '../../../../../models/user_model.dart';

class AuthenticationLocalDataSource extends BaseLocalDataSource {
  // Local
  FutureEitherAppException<bool> saveUserToStorage(UserModel? user) async {
    final result = AppException().handleExceptionAsync(() async {
      if (user == null) return false;
      return await sharedPrefs.setString(
        StorageConstants.user,
        jsonEncode(user.toJson()),
      );
    });
    return result;
  }

  FutureEitherAppException<UserModel?> getUserFromStorage() async {
    final result = AppException().handleException(() {
      final rawString = sharedPrefs.getString(StorageConstants.user);
      if (rawString.isNotNullAndEmpty) {
        return UserModel.fromJson(jsonDecode(rawString!));
      }
      return null;
    });
    return result;
  }

  // remove account from storage
  FutureEitherAppException<bool> removeUserFromStorage() async {
    final result = AppException().handleExceptionAsync(() async {
      return await sharedPrefs.remove(StorageConstants.user);
    });
    return result;
  }
}
