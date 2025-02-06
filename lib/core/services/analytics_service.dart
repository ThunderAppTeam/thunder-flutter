import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:thunder/core/services/log_service.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  AnalyticsService._();

  // Screen tracking
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    LogService.info('Screen View: $screenName');
    if (!kDebugMode) {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    }
  }

  // Custom events
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    LogService.info('Event: $name, Params: $parameters');
    if (!kDebugMode) {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    }
  }

  // User properties
  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    LogService.info('User Property: $name = $value');

    if (!kDebugMode) {
      await _analytics.setUserProperty(
        name: name,
        value: value,
      );
    }
  }
}
