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
  measure,
  archive,
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

  void _onMeasureTap() async {
    await ref.read(permissionServiceProvider).requestCameraPermission();
    if (mounted) {
      ref.read(safeRouterProvider).pushNamed(context, Routes.measure.name);
    }
  }

  void _onTap(BuildContext context, Tabs tab) {
    if (tab == Tabs.measure) {
      _onMeasureTap();
      return;
    }
    // 카메라 탭을 건너뛰고 매핑
    final adjustedIndex =
        tab.index > Tabs.measure.index ? tab.index - 1 : tab.index;
    widget.navigationShell.goBranch(adjustedIndex);
  }

  int _getSelectedIndex() {
    // 브랜치 인덱스를 탭 인덱스로 변환 (카메라 탭을 건너뛰고 매핑)
    final branchIndex = widget.navigationShell.currentIndex;
    return branchIndex >= Tabs.measure.index ? branchIndex + 1 : branchIndex;
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Assets.images.logos.thunderLogotypeSmallW.svg(),
                InkWell(
                  onTap: () {
                    ref
                        .read(safeRouterProvider)
                        .pushNamed(context, Routes.settings.name);
                  },
                  child: SizedBox(
                    width: Sizes.icon24,
                    height: Sizes.icon24,
                    child: Assets.images.icons.settings.svg(),
                  ),
                ),
              ],
            ),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationBarItem(
                icon: Assets.images.icons.home,
                activeIcon: Assets.images.icons.homeFilled,
                isSelected: _getSelectedIndex() == Tabs.home.index,
                label: '홈',
                onTap: () => _onTap(context, Tabs.home),
              ),
              _NavigationBarItem(
                icon: Assets.images.icons.create,
                activeIcon: Assets.images.icons.create,
                isSelected: _getSelectedIndex() == Tabs.measure.index,
                label: '측정',
                onTap: () => _onTap(context, Tabs.measure),
              ),
              _NavigationBarItem(
                icon: Assets.images.icons.folder,
                activeIcon: Assets.images.icons.folderFilled,
                isSelected: _getSelectedIndex() == Tabs.archive.index,
                label: '보관함',
                onTap: () => _onTap(context, Tabs.archive),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  final SvgGenImage icon;
  final SvgGenImage activeIcon;
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
            SizedBox(
              width: Sizes.icon24,
              height: Sizes.icon24,
              child: (isSelected ? activeIcon : icon).svg(
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Gaps.v6,
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
