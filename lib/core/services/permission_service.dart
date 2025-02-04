import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

enum PermissionType {
  notification,
  tracking,
  camera,
}

class PermissionService {
  static Permission _getPermission(PermissionType type) {
    return switch (type) {
      PermissionType.notification => Permission.notification,
      PermissionType.tracking => Permission.appTrackingTransparency,
      PermissionType.camera => Permission.camera,
    };
  }

  static Future<bool> checkPermissionDenied(
      PermissionType permissionType) async {
    final permission = _getPermission(permissionType);
    final isDenied = await permission.isDenied;
    return isDenied;
  }

  static Future<PermissionStatus> requestPermission(
    PermissionType permissionType,
  ) async {
    final permission = _getPermission(permissionType);
    final status = await permission.request();
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

  static Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }
}
