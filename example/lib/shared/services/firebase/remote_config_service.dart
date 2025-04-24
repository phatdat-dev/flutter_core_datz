part of 'firebase_service.dart';

mixin RemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;
  final _baseUrlServer = 'base_url_server';

  Future<void> remoteConfigServiceInitialize() async {
    await Future.wait([
      remoteConfig.ensureInitialized(),
      // remoteConfig.setConfigSettings(
      //   RemoteConfigSettings(
      //     fetchTimeout: const Duration(seconds: 10),
      //     minimumFetchInterval: Duration.zero,
      //   ),
      // ),
      remoteConfig.fetchAndActivate(),
    ]);

    // Listen for future fetch events.
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();

      // Use the new config values here.
      if (event.updatedKeys.contains(_baseUrlServer)) handleRemoteConfigBaseURL();
    });
    // set default value
    handleRemoteConfigBaseURL();
  }

  String getBaseURLServer() => remoteConfig.getString(_baseUrlServer);

  void handleRemoteConfigBaseURL() {
    if (kDebugMode) return;
    //update URL
    final url = getBaseURLServer();
    Printt.cyan('--NEW BASE URL-- $url');
    if (url.isEmpty) return;
    GetIt.instance<DioNetworkService>().dio.options.baseUrl = url;
  }
}
