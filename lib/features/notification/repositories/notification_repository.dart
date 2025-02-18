import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/network/dio_options.dart';
import 'package:thunder/core/network/dio_provider.dart';
import 'package:thunder/core/network/repository/base_repository.dart';
import 'package:thunder/core/services/log_service.dart';
import 'package:thunder/features/notification/models/data/notification_data.dart';

class NotificationRepository extends BaseRepository {
  NotificationRepository(super.dio);
  Future<Map<String, dynamic>> fetchNotificationSettings() async {
    final path = '/v1/member';
    return await get(
      path,
      options: DioOptions.tokenOptions,
    );
  }

  Future<void> postFCMToken(String token) async {
    final path = '/v1/member/fcm-token';
    try {
      await post(
        path,
        data: {'fcmToken': token},
        options: DioOptions.tokenOptions,
      );
    } catch (e) {
      LogService.error('Failed to post FCM token: $token');
    }
  }

  Future<void> postNotificationSettings(NotificationData data) async {
    final path = '/v1/member/settings/notification';
    return await post(
      path,
      data: data,
      options: DioOptions.tokenOptions,
    );
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.read(dioProvider));
});
