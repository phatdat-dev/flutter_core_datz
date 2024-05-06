// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app/app_globals.dart';
import '../../utils/utils.dart';

class NetworkConnectivityService {
  final _networkConnectivity = Connectivity();
  final _debouncer = Debouncer(delay: const Duration(seconds: 3));
  GlobalKey _keyPopup = GlobalKey();
  bool _isOnline = false;
  bool _initSuccess = false;
  // 1.
  void onInit() async {
    if (_initSuccess) return;
    List<ConnectivityResult> result = await _networkConnectivity.checkConnectivity();
    await _checkStatus(result, showSnackBar: false);
    // lúc vô trong _checkStatus nó sẽ set lại true
    // để tránh gọi snackbar khi onConnectivityChanged lần đầu nên đật initSuccess = false ở đây
    _initSuccess = false;

    _networkConnectivity.onConnectivityChanged.listen((result) {
      // nhiều khi mạng bị chập nên delay 3s để tránh bị gọi liên tục vào func này
      _debouncer.call(() => _checkStatus(result));
    });
  }

// 2.
  Future<void> _checkStatus(List<ConnectivityResult> result, {bool showSnackBar = true}) async {
    const String address = 'google.com';

    if (!result.contains(ConnectivityResult.none)) {
      try {
        final result = await InternetAddress.lookup(address);
        _isOnline = (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
      } on SocketException catch (_) {
        _isOnline = false;
      }
    } else {
      _isOnline = false;
    }

    Printt.cyan('NetworkConnectivity isOnline: $_isOnline');

    if (!_isOnline) {
      showSnackBar ? _showSnackBarMessage('No Internet') : _showDialogDisconnect();
    } else {
      // auto close dialog
      final context = _keyPopup.currentContext;
      if (context != null) Navigator.of(context).pop();
      if (showSnackBar && _initSuccess) _showSnackBarMessage('Internet connected');
    }
    _initSuccess = true;
  }

  void _showDialogDisconnect() {
    showCupertinoDialog(
      context: AppGlobals.context,
      builder: (context) => CupertinoAlertDialog(
        key: _keyPopup,
        title: const Text('No Internet'),
        content: const Text('Please check your internet connection'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _keyPopup = GlobalKey();
              if (_isOnline == false) _showDialogDisconnect();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(AppGlobals.context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
