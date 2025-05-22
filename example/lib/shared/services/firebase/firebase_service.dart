import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

import '../../datasource/network/dio_network_service.dart';

part 'firestore_service.dart';
part 'notification_service.dart';
part 'remote_config_service.dart';

class FireBaseService
    with FireStoreService, NotificationService, RemoteConfigService {}
