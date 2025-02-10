import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/services/permission_service.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/features/permission/widgets/permission_guide_title.dart';
import 'package:thunder/features/permission/widgets/permission_modal.dart';
import 'package:thunder/generated/l10n.dart';

class NotificationPermissionPage extends ConsumerWidget {
  const NotificationPermissionPage({super.key});

  void _onTapAllow(WidgetRef ref, BuildContext context) async {
    await PermissionService.requestPermission(PermissionType.notification);
    if (context.mounted) {
      _checkTrackingPermissionAndRoute(ref, context);
    }
  }

  void _onTapDeny(WidgetRef ref, BuildContext context) {
    _checkTrackingPermissionAndRoute(ref, context);
  }

  Future<void> _checkTrackingPermissionAndRoute(
      WidgetRef ref, BuildContext context) async {
    if (Platform.isIOS) {
      final isDenied = await PermissionService.checkPermissionDenied(
          PermissionType.tracking);
      if (context.mounted) {
        if (isDenied) {
          ref
              .read(safeRouterProvider)
              .pushNamed(context, Routes.permission.tracking.name);
        } else {
          ref.read(safeRouterProvider).goToHome(context);
        }
      }
    } else {
      ref.read(safeRouterProvider).goToHome(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modalWidth = 270.0;
    final modalHeight = 165.0;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Transform.translate(
              offset: Offset(0, -modalHeight / 2 - Sizes.spacing56),
              child: PermissionGuideTitle(
                title: S.of(context).permissionNotificationTitle,
              ),
            ),
          ),
          Center(
            child: PermissionModal(
              modalWidth: modalWidth,
              title: S.of(context).permittionNotificationModalTitle,
              description: S.of(context).permissionNotificationModalDescription,
              denyText: S.of(context).permissionNotificationModalDenyText,
              allowText: S.of(context).permissionNotificationModalAllowText,
              buttonDirection: PermissionModalButtonDirection.horizontal,
              onTapDeny: () => _onTapDeny(ref, context),
              onTapAllow: () => _onTapAllow(ref, context),
            ),
          ),
        ],
      ),
    );
  }
}
