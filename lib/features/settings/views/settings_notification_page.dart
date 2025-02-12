import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thunder/core/services/permission_service.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/features/settings/widgets/settings_banner.dart';
import 'package:thunder/features/settings/widgets/settings_list_tile.dart';
import 'package:thunder/generated/l10n.dart';

class SettingsNotificationPage extends StatefulWidget {
  const SettingsNotificationPage({super.key});

  @override
  State<SettingsNotificationPage> createState() =>
      _SettingsNotificationPageState();
}

class _SettingsNotificationPageState extends State<SettingsNotificationPage>
    with WidgetsBindingObserver {
  bool _notificationEnabled = false;
  bool isReceiveBodycheckComplete = false;
  bool isReceiveBodycheckRequest = false;
  bool isReceiveMarketing = false;

  void _initPermission() async {
    final status =
        await PermissionService.requestPermission(PermissionType.notification);
    setState(() {
      _notificationEnabled = status == PermissionStatus.granted;
      if (!_notificationEnabled) {
        isReceiveBodycheckComplete = false;
        isReceiveBodycheckRequest = false;
      }
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

  @override
  Widget build(BuildContext context) {
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
          SettingsListTile(
            title: S.of(context).settingsNotificationBodycheckComplete,
            trailing: SettingsTrailing.toggle(
              toggleValue: isReceiveBodycheckComplete,
              toggleOnChanged: (value) {
                setState(() {
                  isReceiveBodycheckComplete = value;
                });
              },
            ),
          ),
          SettingsListTile(
            title: S.of(context).settingsNotificationBodycheckRequest,
            trailing: SettingsTrailing.toggle(
              toggleValue: isReceiveBodycheckRequest,
              toggleOnChanged: (value) {
                setState(() {
                  isReceiveBodycheckRequest = value;
                });
              },
            ),
          ),
          SettingsListTile(
            title: S.of(context).settingsNotificationMarketing,
            trailing: SettingsTrailing.toggle(
              toggleValue: isReceiveMarketing,
              toggleOnChanged: (value) {
                setState(() {
                  isReceiveMarketing = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
