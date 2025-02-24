import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/services/permission_service.dart';

class PermissionNavigationService {
  static Future<bool> requestPermissionsAndRoute(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // 알림 권한 요청
    final isNotificationDenied = await PermissionService.checkPermissionDenied(
        PermissionType.notification);
    if (isNotificationDenied) {
      if (context.mounted) {
        ref
            .read(safeRouterProvider)
            .pushNamed(context, Routes.permission.notification.name);
      }
      return true;
    }
    return false;
  }
}
