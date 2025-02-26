import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:thunder/core/services/log_service.dart';
import 'package:thunder/core/constants/analytics_const.dart';

enum AnalyticsTabName {
  home,
  check,
  archive,
}

enum AnalyticsPhotoSource {
  camera,
  gallery,
}

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  AnalyticsService._();

  // Base event tracking method
  static Future<void> _trackEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    try {
      if (parameters != null) {
        LogService.info('Analytics Event: $name, Params: $parameters');
      } else {
        LogService.info('Analytics Event: $name');
      }
      if (kDebugMode) return;
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e, stack) {
      LogService.error(
        'Failed to track event: $name',
        error: e,
        stackTrace: stack,
      );
    }
  }

  // User ID Management
  static Future<void> setUserId(String? userId) async {
    try {
      LogService.info('Analytics: Set User ID - $userId');
      if (kDebugMode) return;
      await _analytics.setUserId(id: userId);
    } catch (e, stack) {
      LogService.error('Failed to set user ID', error: e, stackTrace: stack);
    }
  }

  static Future<void> resetUserId() async {
    try {
      LogService.info('Analytics: Reset User ID');
      if (kDebugMode) return;
      await _analytics.setUserId(id: AnalyticsValue.nullValue);
    } catch (e, stack) {
      LogService.error('Failed to reset user ID', error: e, stackTrace: stack);
    }
  }

  // User Properties
  static Future<void> setUserProperties({
    required String gender,
    required int age,
  }) async {
    try {
      LogService.info(
          'Analytics: Set User Properties - Gender: $gender, Age: $age');
      if (kDebugMode) return;
      await _analytics.setUserProperty(
        name: AnalyticsUserProperty.userGender,
        value: gender,
      );
      await _analytics.setUserProperty(
        name: AnalyticsUserProperty.userAge,
        value: age.toString(),
      );
    } catch (e, stack) {
      LogService.error('Failed to set user properties',
          error: e, stackTrace: stack);
    }
  }

  // Screen tracking
  static Future<void> screenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      LogService.info('Analytics: Screen View - $screenName');
      if (kDebugMode) return;
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e, stack) {
      LogService.error('Failed to log screen view',
          error: e, stackTrace: stack);
    }
  }

  // Auth Events
  static Future<void> authPhoneStart() async {
    await _trackEvent(AnalyticsEvent.authPhoneStart);
  }

  static Future<void> authPhone() async {
    await _trackEvent(AnalyticsEvent.authPhone);
  }

  static Future<void> login() async {
    await _trackEvent(
      AnalyticsEvent.login,
      parameters: {AnalyticsParam.method: AnalyticsValue.auth.sms},
    );
  }

  static Future<void> signUpStart() async {
    await _trackEvent(AnalyticsEvent.signUpStart);
  }

  static Future<void> signUp() async {
    await _trackEvent(
      AnalyticsEvent.signUp,
      parameters: {AnalyticsParam.method: AnalyticsValue.auth.sms},
    );
  }

  static Future<void> logout() async {
    await _trackEvent(AnalyticsEvent.logout);
  }

  static Future<void> deleteAccount() async {
    await _trackEvent(AnalyticsEvent.deleteAccount);
  }

  // Content Events
  static Future<void> reviewBody({
    required String contentId,
    required int score,
  }) async {
    await _trackEvent(
      AnalyticsEvent.reviewBody,
      parameters: {
        AnalyticsParam.reviewedContent: contentId,
        AnalyticsParam.reviewScore: score,
      },
    );
  }

  static Future<void> tabTap(AnalyticsTabName tabName) async {
    await _trackEvent(
      AnalyticsEvent.tapTab,
      parameters: {
        AnalyticsParam.tabName: switch (tabName) {
          AnalyticsTabName.home => AnalyticsValue.tab.home,
          AnalyticsTabName.check => AnalyticsValue.tab.check,
          AnalyticsTabName.archive => AnalyticsValue.tab.archive,
        }
      },
    );
  }

  static Future<void> selectPhoto(AnalyticsPhotoSource photoSource) async {
    await _trackEvent(
      AnalyticsEvent.selectPhoto,
      parameters: {
        AnalyticsParam.photoSource: switch (photoSource) {
          AnalyticsPhotoSource.camera => AnalyticsValue.photo.camera,
          AnalyticsPhotoSource.gallery => AnalyticsValue.photo.gallery,
        }
      },
    );
  }

  static Future<void> uploadPhoto() async {
    await _trackEvent(AnalyticsEvent.uploadPhoto);
  }

  static Future<void> viewBodyResult(int bodyPhotoId) async {
    await _trackEvent(AnalyticsEvent.viewBodyResult, parameters: {
      AnalyticsParam.viewedContentId: bodyPhotoId,
    });
  }

  static Future<void> share(int bodyPhotoId) async {
    await _trackEvent(AnalyticsEvent.share, parameters: {
      AnalyticsParam.method: AnalyticsValue.share.image,
      AnalyticsParam.contentType: AnalyticsValue.share.bodyResult,
      AnalyticsParam.itemId: bodyPhotoId,
    });
  }

  static Future<void> deleteContent(int bodyPhotoId) async {
    await _trackEvent(AnalyticsEvent.deleteContent, parameters: {
      AnalyticsParam.deletedContentId: bodyPhotoId,
    });
  }

  static Future<void> reportContent(int bodyPhotoId) async {
    await _trackEvent(AnalyticsEvent.reportContent, parameters: {
      AnalyticsParam.reportedContentId: bodyPhotoId,
    });
  }

  static Future<void> blockUser(String userId) async {
    await _trackEvent(AnalyticsEvent.blockUser, parameters: {
      AnalyticsParam.blockedUserId: userId,
    });
  }
}
