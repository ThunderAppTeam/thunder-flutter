import 'package:flutter/material.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/features/settings/widgets/settings_list_tile.dart';

class SettingsNotificationPage extends StatefulWidget {
  const SettingsNotificationPage({super.key});

  @override
  State<SettingsNotificationPage> createState() =>
      _SettingsNotificationPageState();
}

class _SettingsNotificationPageState extends State<SettingsNotificationPage> {
  bool isReceiveMarketing = true;
  bool isReceiveBodycheckComplete = true;
  bool isReceiveBodycheckRequest = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "알림"),
      body: Column(
        children: [
          SettingsListTile(
            title: "눈바디 측정 완료",
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
            title: "눈바디 평가 요청",
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
            title: "마케팅 수신 동의",
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
