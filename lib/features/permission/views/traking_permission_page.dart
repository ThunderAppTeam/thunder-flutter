import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/services/permission_service.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/features/permission/widgets/permission_guide_title.dart';
import 'package:thunder/features/permission/widgets/permission_modal.dart';

class TrackingPermissionPage extends ConsumerWidget {
  const TrackingPermissionPage({super.key});

  void _onTapAllow(WidgetRef ref, BuildContext context) async {
    await PermissionService.requestTrackingPermission();
    if (context.mounted) {
      ref.read(safeRouterProvider).goToHome(context);
    }
  }

  void _onTapDeny(WidgetRef ref, BuildContext context) {
    ref.read(safeRouterProvider).goToHome(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modalWidth = 270.0;
    final modalHeight = 230.0;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Transform.translate(
              offset: Offset(0, -modalHeight / 2 - Sizes.spacing56),
              child:
                  PermissionGuideTitle(title: '불필요한 광고를 보지 않으시려면\n추적을 허용해주세요'),
            ),
          ),
          Center(
            child: PermissionModal(
              modalWidth: modalWidth,
              title: 'Thunder 앱이 다른 회사의 앱 및 웹사이트에 걸친 사용자의 활동을 추적하도록 허용하겠습니까?',
              description: '허용을 누르면 불필요한 내용의 광고가 아닌 관심사 기반 맞춤형 정보를 제공해드려요.',
              denyText: '앱에 추적 금지 요청',
              allowText: '허용',
              buttonDirection: PermissionModalButtonDirection.vertical,
              onTapDeny: () => _onTapDeny(ref, context),
              onTapAllow: () => _onTapAllow(ref, context),
            ),
          ),
        ],
      ),
    );
  }
}
