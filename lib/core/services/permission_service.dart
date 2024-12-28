import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class PermissionService {
  Future<PermissionStatus> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status;
  }

  Future<TrackingStatus> requestTrackingPermission() async {
    if (Platform.isIOS) {
      return await AppTrackingTransparency.requestTrackingAuthorization();
    }
    return TrackingStatus.notSupported;
  }

  Future<void> resetPermissions() async {
    // 알림 권한 초기화를 위해 앱 설정으로 이동
    await openAppSettings();
  }
}

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});
