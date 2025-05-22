import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:get_it/get_it.dart';
import 'package:upgrader/upgrader.dart';

import '../../generated/assets.gen.dart';

/// Check if VPN or Proxy is detected before checking for app updates

class CheckAppView extends StatefulWidget {
  const CheckAppView({super.key, required this.child, this.navigatorKey});
  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  State<CheckAppView> createState() => _CheckAppViewState();
}

class _CheckAppViewState extends State<CheckAppView> {
  late final Upgrader upgrader;

  @override
  void initState() {
    GetIt.instance<NetworkConnectivityService>().onInit();
    upgrader = Upgrader(
      durationUntilAlertAgain: const Duration(minutes: 1),
      debugLogging: false,
      // debugDisplayAlways: true,
    );

    super.initState();
  }

  Future<bool> isVPNDetected() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.vpn)) return true;

    return false;
  }

  bool isProxyDetected() {
    final env = Platform.environment;
    String? httpProxy = HttpClient.findProxyFromEnvironment(
      Uri.parse("http://www.example.com"),
    );
    return env.containsKey('http_proxy') ||
        env.containsKey('https_proxy') ||
        httpProxy != "DIRECT";
  }

  Future<bool> checkProxyAndVPN() async {
    final bool isVPN = await isVPNDetected();
    final bool isProxy = isProxyDetected();
    return isVPN || isProxy;
  }

  @override
  Widget build(BuildContext context) {
    // DashboardView(widget.navigationShell, widget.children)
    return buildCheckProxyAndVPN(
      context,
      buildCheckVersion(context, widget.child),
    );
  }

  Widget _buildLoadding() => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Waiting to check VPN & Version..."),
          CircleAvatar(
            radius: 150,
            backgroundImage: AssetImage(Assets.images.logo.logo.keyName),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    ),
  );

  Widget buildCheckProxyAndVPN(BuildContext context, Widget child) {
    return FutureBuilder(
      future: checkProxyAndVPN(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.yellow,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Please turn off VPN and Proxy to use the app',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return child;
          }
        }
        return _buildLoadding();
      },
    );
  }

  Widget buildCheckVersion(BuildContext context, Widget child) {
    return UpgradeAlert(
      navigatorKey: widget.navigatorKey,
      dialogStyle: UpgradeDialogStyle.cupertino,
      showIgnore: false,
      showLater: false,
      upgrader: upgrader,
      child: StreamBuilder(
        stream: upgrader.stateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return upgrader.shouldDisplayUpgrade() ? _buildLoadding() : child;
          }
          return _buildLoadding();
        },
      ),
    );
  }
}
