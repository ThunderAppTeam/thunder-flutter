import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:thunder/core/services/log_service.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize FCM settings and request permissions
  static Future<void> initialize() async {
    try {
      // Get FCM token
      String? token = await _messaging.getToken();
      LogService.debug('FCM Token: $token');

      // Save this token to your backend for later use
      if (token != null) {
        // TODO: Send token to your backend
      }

      // Handle token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        LogService.debug('FCM Token refreshed: $newToken');
        // TODO: Send new token to your backend
      });

      // Handle incoming messages when app is in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        LogService.debug('Got a message whilst in the foreground!');
        LogService.trace('Message data: ${message.data}');
        if (message.notification != null) {
          LogService.debug(
            'Message also contained a notification: ${message.notification}',
          );
        }
      });
      // Handle message when app is in background and user taps notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        LogService.debug(
          'A new onMessageOpenedApp event was published! ${message.data}',
        );
        // TODO: Handle notification tap
      });
    } catch (e) {
      LogService.error('FCM initialization error: $e');
    }
  }

  // /// Subscribe to a specific topic
  // static Future<void> subscribeToTopic(String topic) async {
  //   await _messaging.subscribeToTopic(topic);
  // }

  // /// Unsubscribe from a specific topic
  // static Future<void> unsubscribeFromTopic(String topic) async {
  //   await _messaging.unsubscribeFromTopic(topic);
  // }
}
