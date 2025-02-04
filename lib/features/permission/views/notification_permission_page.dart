import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/services/permission_service.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/features/permission/widgets/permission_guide_title.dart';
import 'package:thunder/features/permission/widgets/permission_modal.dart';

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
    final isDenied =
        await PermissionService.checkPermissionDenied(PermissionType.tracking);
    if (context.mounted) {
      if (isDenied) {
        ref
            .read(safeRouterProvider)
            .pushNamed(context, Routes.permissionTracking.name);
      } else {
        ref.read(safeRouterProvider).goToHome(context);
      }
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
              child: const PermissionGuideTitle(
                title: 'Thunder를 편리하게 이용하려면\n알림을 허용해주세요',
              ),
            ),
          ),
          Center(
            child: PermissionModal(
              modalWidth: modalWidth,
              title: 'Thunder를 편리하게 이용하려면\n알림을 허용해주세요',
              description:
                  '경고, 사운드 및 아이콘 배지가 알림에 포함될 수 있습니다. 설정에서 이를 구성할 수 있습니다.',
              denyText: '허용 안 함',
              allowText: '허용',
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
