import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/app/router/router.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/services/analytics_service.dart';
import 'package:thunder/core/services/permission_service.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/generated/l10n.dart';

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
  late final RouterDelegate<Object> _routerDelegate;
  @override
  void initState() {
    super.initState();
    _routerDelegate = ref.read(routerProvider).routerDelegate;
    _routerDelegate.addListener(_handleRouteChange);
  }

  void _handleRouteChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final config =
          ref.read(routerProvider).routerDelegate.currentConfiguration;
      final screenName = config.last.route.name;

      if (screenName != null) {
        if (screenName == Routes.home.name ||
            screenName == Routes.archive.name) {
          final extra = config.extra as Map<String, dynamic>?;
          if (extra?[KeyConst.skipAnalytics] == true) return;
          AnalyticsService.screenView(screenName: screenName);
        }
      }
    });
  }

  void _onMeasureTap() async {
    await PermissionService.requestPermission(PermissionType.camera);
    if (mounted) {
      ref.read(safeRouterProvider).pushNamed(context, Routes.camera.name);
    }
  }

  void _onTap(BuildContext context, Tabs tab) {
    AnalyticsService.tabTap(
      switch (tab) {
        Tabs.home => AnalyticsTabName.home,
        Tabs.measure => AnalyticsTabName.check,
        Tabs.archive => AnalyticsTabName.archive,
      },
    );
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
  void dispose() {
    _routerDelegate.removeListener(_handleRouteChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          toolbarHeight: Sizes.appBarHeight48,
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
                  customBorder: CircleBorder(),
                  onTap: () {
                    ref
                        .read(safeRouterProvider)
                        .pushNamed(context, Routes.settings.name);
                  },
                  child: Icon(
                    size: Sizes.icon24,
                    ThunderIcons.settings,
                    color: ColorName.white,
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
                icon: ThunderIcons.home,
                activeIcon: ThunderIcons.homeFilled,
                isSelected: _getSelectedIndex() == Tabs.home.index,
                label: S.of(context).navigationLabelHome,
                onTap: () => _onTap(context, Tabs.home),
              ),
              _NavigationBarItem(
                icon: ThunderIcons.create,
                activeIcon: ThunderIcons.create,
                isSelected: _getSelectedIndex() == Tabs.measure.index,
                label: S.of(context).navigationLabelMeasure,
                onTap: () => _onTap(context, Tabs.measure),
              ),
              _NavigationBarItem(
                icon: ThunderIcons.folder,
                activeIcon: ThunderIcons.folderFilled,
                isSelected: _getSelectedIndex() == Tabs.archive.index,
                label: S.of(context).navigationLabelArchive,
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
      child: Container(
        width: Sizes.navigationTabWidth,
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
