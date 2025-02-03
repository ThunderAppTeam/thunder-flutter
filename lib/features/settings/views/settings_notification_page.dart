import 'package:flutter/material.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';

class SettingsNotificationPage extends StatelessWidget {
  const SettingsNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "알림"),
      body: Column(
        children: [
          Text("알림"),
        ],
      ),
    );
  }
}
