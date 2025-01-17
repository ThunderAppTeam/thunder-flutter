import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class PermissionService {
  static Future<PermissionStatus> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status;
  }

  static Future<TrackingStatus> requestTrackingPermission() async {
    if (Platform.isIOS) {
      return await AppTrackingTransparency.requestTrackingAuthorization();
    }
    return TrackingStatus.notSupported;
  }

  static Future<void> resetPermissions() async {
    // 알림 권한 초기화를 위해 앱 설정으로 이동
    await openAppSettings();
  }

  static Future<PermissionStatus> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status;
  }

  static Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }
}
