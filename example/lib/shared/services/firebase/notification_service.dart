part of 'firebase_service.dart';

mixin NotificationService {
  final localNotification = FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel
  get androidNotifiChannel => const AndroidNotificationChannel(
    'default-channel-id',
    'default-channel-name',
    description: 'default description',
    enableLights: true,
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
    //sound: RawResourceAndroidNotificationSound('ckc_social_app_notification_sound'),
    // sound: UriAndroidNotificationSound('assets/sound/gmc_notification_sound.mp3')
  );

  Future<void> notificationServiceInitialize() async {
    await _initLocalNotification();

    await _requestPermissionApp();

    getDeviceFirebaseToken();

    firebaseMessagingForegroundHandler();
    firebaseMessagingSubscribeTopic('all', true);
  }

  Future<void> _initLocalNotification() async {
    // ở android, tạo channel cho notification
    await localNotification
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          androidNotifiChannel,
        );
    //

    //setting notification
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    //add setting
    localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) async {
        //bắt sự kiện click vào notification đẩy nó vào stream
        Printt.white('onDidReceiveNotificationResponse ${details.payload}');
      },
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
  }

  // gửi yêu cầu đến người dùng cấp quyền cho app
  Future<void> _requestPermissionApp() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
  }

  Future<String?> getDeviceFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    Printt.cyan('TOKEN DEVICE: $token');
    return token;
  }

  Future<void> showNotification(RemoteMessage message) async {
    ByteArrayAndroidBitmap? imageBitMap;
    if (message.data['image'] != null) {
      Uint8List bodyBytes = (await NetworkAssetBundle(
        Uri.parse(message.data['image']),
      ).load(message.data['image'])).buffer.asUint8List();

      imageBitMap = ByteArrayAndroidBitmap.fromBase64String(
        base64Encode(bodyBytes),
      );
    }

    return localNotification.show(
      message.messageId.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidNotifiChannel.id,
          androidNotifiChannel.name,
          channelDescription: androidNotifiChannel.description,
          enableLights: androidNotifiChannel.enableLights,
          importance: androidNotifiChannel.importance,
          enableVibration: androidNotifiChannel.enableVibration,
          playSound: androidNotifiChannel.playSound,
          priority: Priority.max,
          sound: androidNotifiChannel.sound,
          icon: '@drawable/splash',
          // largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          largeIcon: imageBitMap,
          styleInformation: imageBitMap != null
              ? BigPictureStyleInformation(imageBitMap)
              : null,
        ),
        // iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data['payload'],
    );
  }

  void firebaseMessagingForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        Printt.white('show notification from ${message.from}}');
        showNotification(message);
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    //TODO: Firebase
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    Printt.white('Handling a background messagee: ${message.messageId}');
  }

  static void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse details,
  ) {
    Printt.white(
      'onDidReceiveBackgroundNotificationResponse ${details.payload}',
    );
  }

  Future<void> firebaseMessagingSubscribeTopic(
    String topic,
    bool enable,
  ) async {
    if (enable) {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    }
  }
}
