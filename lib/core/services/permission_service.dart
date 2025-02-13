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

  static Future<bool> checkPermissionGranted(
    PermissionType permissionType,
  ) async {
    final permission = _getPermission(permissionType);
    final isGranted = await permission.isGranted;
    return isGranted;
  }

  static Future<TrackingStatus> requestTrackingPermission() async {
    return await AppTrackingTransparency.requestTrackingAuthorization();
  }

  static Future<bool> openSettings() async {
    // 알림 권한 초기화를 위해 앱 설정으로 이동
    return await openAppSettings();
  }

  static Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }
}
