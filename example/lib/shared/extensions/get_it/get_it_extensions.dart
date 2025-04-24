import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

extension GetItExtension on GetIt {
  // same resetLazySingleton
  Future<T> refresh<T extends Object>(ValueGetter<T> factoryFunc, {String? instanceName}) async {
    if (isRegistered<T>(instanceName: instanceName)) await unregister<T>(instanceName: instanceName);
    return registerSingleton<T>(factoryFunc(), instanceName: instanceName);
  }

  // Get or Create
  T getOrRegisterSingleton<T extends Object>(ValueGetter<T> factoryFunc) {
    if (!isRegistered<T>()) registerSingleton<T>(factoryFunc());
    return get<T>();
  }

  T? getOrNull<T extends Object>() {
    if (isRegistered<T>()) return get<T>();
    return null;
  }
}
