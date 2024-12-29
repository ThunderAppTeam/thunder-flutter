import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/time_consts.dart';
import 'package:thunder/core/services/permission_service.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissions();
    });
  }

  Future<void> _requestPermissions() async {
    // 알림 권한 요청
    await ref.read(permissionServiceProvider).requestNotificationPermission();
    // 앱 추적 권한 요청 (iOS only)
    if (Platform.isIOS) {
      await Future.delayed(TimeConsts.permissionPopupDuration);
      await ref.read(permissionServiceProvider).requestTrackingPermission();
    }
  }

  void _onCameraTap() async {
    await ref.read(permissionServiceProvider).requestCameraPermission();
    if (mounted) {
      SafeRouter.pushNamed(context, Routes.camera.name);
    }
  }

  void _onTap(BuildContext context, int index) {
    if (index == 1) {
      _onCameraTap();
      return;
    }
    // 카메라 탭을 건너뛰고 매핑
    final adjustedIndex = index > 1 ? index - 1 : index;
    widget.navigationShell.goBranch(adjustedIndex);
  }

  int _getSelectedIndex() {
    // 브랜치 인덱스를 탭 인덱스로 변환 (카메라 탭을 건너뛰고 매핑)
    final branchIndex = widget.navigationShell.currentIndex;
    return branchIndex >= 1 ? branchIndex + 1 : branchIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.spacing16,
              vertical: Sizes.spacing8,
            ),
            child: Assets.images.thunderLogotypeSmallW.svg(),
          ),
          titleSpacing: Sizes.zero,
        ),
        body: widget.navigationShell,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.spacing16,
            vertical: Sizes.spacing8,
          ), // 전체 좌우 패딩
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
            children: [
              _NavigationBarItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                isSelected: _getSelectedIndex() == 0,
                onTap: () => _onTap(context, 0),
              ),
              _NavigationBarItem(
                icon: Icons.add_box_outlined,
                activeIcon: Icons.add_box,
                isSelected: _getSelectedIndex() == 1,
                onTap: () => _onTap(context, 1),
              ),
              _NavigationBarItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                isSelected: _getSelectedIndex() == 2,
                onTap: () => _onTap(context, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationBarItem({
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.spacing40,
          vertical: Sizes.spacing6,
        ),
        child: Icon(
          size: Sizes.icon24,
          isSelected ? activeIcon : icon,
          color: ColorName.white,
        ),
      ),
    );
  }
}
