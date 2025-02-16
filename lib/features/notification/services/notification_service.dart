import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/app/router/router.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/core/services/log_service.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/features/notification/repositories/notification_repository.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // // android background handler
  LogService.debug('_firebaseMessagingBackgroundHandler: ${message.data}');
  // await Firebase.initializeApp();
  // await NotificationService.instance.setupLocalNotifications();
  // // await NotificationService.instance.showNotification(message);
}

class NotificationConst {
  static const channelId = 'high_importance_channel';
  static const channelName = 'Thunder Notifications';
  static const channelDescription = 'Check your thunder notifications';
  static const channelImportance = Importance.max;
}

class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;
  String? _fcmToken;
  RemoteMessage? _initialMessage;
  late final WidgetRef _ref;

  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await setupLocalNotifications();

    // initialize message handlers
    await _setupMessageHandlers();

    // Get FCM token
    await _setupFCMToken();

    if (_fcmToken != null) {
      // subscribe to all topic
      // await subscribeToTopic('all');
    }
  }

  set ref(WidgetRef ref) => _ref = ref;

  Future<void> setupTokenRefreshListener() async {
    _messaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
      _ref.read(notificationRepositoryProvider).postFCMToken(_fcmToken!);
    });
  }

  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      LogService.debug('User granted permission');
    } else {
      LogService.debug('User denied permission');
    }
  }

  Future<void> sendFCMTokenToServer() async {
    if (_fcmToken == null) return;
    await _ref.read(notificationRepositoryProvider).postFCMToken(_fcmToken!);
  }

  Future<void> setupLocalNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');

    final channel = AndroidNotificationChannel(
      NotificationConst.channelId,
      NotificationConst.channelName,
      description: NotificationConst.channelDescription,
      importance: NotificationConst.channelImportance,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
// ios setup

    final initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifications.initialize(
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      ),
      onDidReceiveNotificationResponse: (details) {
        LogService.debug(
            'onDidReceiveNotificationResponse: ${details.payload}');
        _handleNotificationData(jsonDecode(details.payload ?? '{}'));
      },
    );
    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification == null || android == null) return;
    final imageUrl = android.imageUrl;
    BigPictureStyleInformation? bigPictureStyleInformation;
    if (imageUrl != null) {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      bigPictureStyleInformation = BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(
          base64Encode(response.bodyBytes),
        ),
        hideExpandedLargeIcon: true,
        largeIcon: ByteArrayAndroidBitmap.fromBase64String(
          base64Encode(response.bodyBytes),
        ),
      );
    }
    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationConst.channelId,
          NotificationConst.channelName,
          largeIcon: bigPictureStyleInformation?.largeIcon,
          channelDescription: NotificationConst.channelDescription,
          importance: NotificationConst.channelImportance,
          styleInformation: bigPictureStyleInformation,
          color: ColorName.black,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  Future<void> _setupMessageHandlers() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // foreground message
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        showNotification(message);
      }
      LogService.debug('Foreground message: ${message.data}');
    });

    // background message
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        LogService.debug('Opened message notification: ${message.data}');
        _handleBackgroundMessage(message);
      },
    );

    // set initial message when open the app
    _initialMessage = await _messaging.getInitialMessage();
  }

  void handleInitialMessage() {
    if (_initialMessage != null) {
      LogService.debug('Handling initial message: ${_initialMessage!.data}');
      _handleBackgroundMessage(_initialMessage!);
      _initialMessage = null;
    }
  }

  Future<void> _handleNotificationData(Map<String, dynamic> data) async {
    final path = data['routePath'];
    if (path == null || navigatorKey.currentContext == null) return;
    if (_isInMainNavigation(path)) {
      GoRouter.of(navigatorKey.currentContext!).goNamed(path);
    } else {
      GoRouter.of(navigatorKey.currentContext!).pushNamed(path);
    }
  }

  bool _isInMainNavigation(String routeName) {
    return routeName == Routes.archive.name || routeName == Routes.home.name;
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await _handleNotificationData(message.data);
  }

  Future<void> _setupFCMToken() async {
    try {
      final apnsToken = await _messaging.getAPNSToken();
      LogService.debug('APNS Token: $apnsToken');
      final token = await _messaging.getToken();
      _fcmToken = token;
      LogService.debug('FCM Token: $token');
    } catch (e) {
      LogService.error('FCM Token error: $e');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    LogService.debug('Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    LogService.debug('Unsubscribed from topic: $topic');
  }
}
