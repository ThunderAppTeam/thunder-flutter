import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/services/permission_service.dart';
import 'package:thunder/core/utils/event_control/debouncer.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/features/notification/view_models/notification_view_models.dart';
import 'package:thunder/features/settings/widgets/settings_banner.dart';
import 'package:thunder/features/settings/widgets/settings_list_tile.dart';
import 'package:thunder/generated/l10n.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SettingsNotificationPage extends ConsumerStatefulWidget {
  const SettingsNotificationPage({super.key});

  @override
  ConsumerState<SettingsNotificationPage> createState() =>
      _SettingsNotificationPageState();
}

class _SettingsNotificationPageState
    extends ConsumerState<SettingsNotificationPage>
    with WidgetsBindingObserver {
  bool _notificationEnabled = true;
  final _debouncer = Debouncer(duration: Duration(seconds: 1));

  void _initPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    setState(() {
      _notificationEnabled =
          settings.authorizationStatus == AuthorizationStatus.authorized;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initPermission();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _initPermission();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _toggleSettings(NotificationSettingsType type, bool value) {
    ref.read(notificationViewModelProvider.notifier).toggle(type, value);
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationViewModelProvider);
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).settingsNotification),
      body: Column(
        children: [
          if (!_notificationEnabled)
            SettingsBanner(
              title: "${S.of(context).settingsNotificationBannerTitle} ⛔️",
              description: S.of(context).settingsNotificationBannerDescription,
              buttonText: S.of(context).settingsNotificationBannerButtonText,
              onButtonTap: () async {
                await PermissionService.openSettings();
              },
            ),
          notificationState.when(
            data: (settings) => Column(
              children: [
                SettingsListTile(
                  title: S.of(context).settingsNotificationBodycheckComplete,
                  trailing: SettingsTrailing.toggle(
                    toggleValue: settings.isReceiveBodyCheckCompleted,
                    toggleOnChanged: (value) => _toggleSettings(
                        NotificationSettingsType.bodyCheckCompleted, value),
                  ),
                ),
                SettingsListTile(
                  title: S.of(context).settingsNotificationBodycheckRequest,
                  trailing: SettingsTrailing.toggle(
                    toggleValue: settings.isReceiveRatingRequest,
                    toggleOnChanged: (value) => _toggleSettings(
                        NotificationSettingsType.ratingRequest, value),
                  ),
                ),
                SettingsListTile(
                  title: S.of(context).settingsNotificationMarketing,
                  trailing: SettingsTrailing.toggle(
                    toggleValue: settings.isMarketingAgreed,
                    toggleOnChanged: (value) => _toggleSettings(
                        NotificationSettingsType.marketingArgree, value),
                  ),
                ),
              ],
            ),
            error: (error, stackTrace) => SizedBox(),
            loading: () => Expanded(
              child: Center(
                child: CustomCircularIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
