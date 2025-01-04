import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/time_consts.dart';
import 'package:thunder/core/services/permission_service.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';

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

enum Tabs {
  home,
  search,
  camera,
  interest,
  profile,
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
      ref.read(safeRouterProvider).pushNamed(context, Routes.camera.name);
    }
  }

  void _onTap(BuildContext context, Tabs tab) {
    if (tab == Tabs.camera) {
      _onCameraTap();
      return;
    }
    // 카메라 탭을 건너뛰고 매핑
    final adjustedIndex =
        tab.index > Tabs.camera.index ? tab.index - 1 : tab.index;
    widget.navigationShell.goBranch(adjustedIndex);
  }

  int _getSelectedIndex() {
    // 브랜치 인덱스를 탭 인덱스로 변환 (카메라 탭을 건너뛰고 매핑)
    final branchIndex = widget.navigationShell.currentIndex;
    return branchIndex >= Tabs.camera.index ? branchIndex + 1 : branchIndex;
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.spacing16,
            vertical: Sizes.spacing2,
          ), // 전체 좌우 패딩
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 가운데 정렬
            children: [
              _NavigationBarItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                isSelected: _getSelectedIndex() == Tabs.home.index,
                label: '홈',
                onTap: () => _onTap(context, Tabs.home),
              ),
              _NavigationBarItem(
                icon: Icons.search_outlined,
                activeIcon: Icons.search,
                isSelected: _getSelectedIndex() == Tabs.search.index,
                label: '탐색',
                onTap: () => _onTap(context, Tabs.search),
              ),
              _NavigationBarItem(
                icon: Icons.add_box_outlined,
                activeIcon: Icons.add_box,
                isSelected: _getSelectedIndex() == Tabs.camera.index,
                label: '측정',
                onTap: () => _onTap(context, Tabs.camera),
              ),
              _NavigationBarItem(
                icon: Icons.favorite_border,
                activeIcon: Icons.favorite,
                isSelected: _getSelectedIndex() == Tabs.interest.index,
                label: '관심',
                onTap: () => _onTap(context, Tabs.interest),
              ),
              _NavigationBarItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                isSelected: _getSelectedIndex() == Tabs.profile.index,
                label: '프로필',
                onTap: () => _onTap(context, Tabs.profile),
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
  final String label;

  const _NavigationBarItem({
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.spacing8,
          vertical: Sizes.spacing4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              size: Sizes.icon24,
              isSelected ? activeIcon : icon,
              color: ColorName.white,
            ),
            Gaps.h6,
            Text(
              label,
              style: textTheme.textBody12,
            ),
          ],
        ),
      ),
    );
  }
}
