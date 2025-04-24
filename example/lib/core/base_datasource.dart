import 'package:dartz/dartz.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:get_it/get_it.dart';

import '../shared/datasource/network/dio_network_service.dart';

typedef FutureEitherAppException<T> = Future<Either<AppException, T>>;

abstract class BaseRemoteDataSource {
  // final apiCall = GetIt.instance<DioNetworkService>();
  final apiCall = GetIt.instance<DioNetworkService>();
}

abstract class BaseLocalDataSource {
  final sharedPrefs = GetIt.instance<StorageService>().sharedPreferences!;
  // final isar = GetIt.instance<StorageService>().cacheDb!;
}
