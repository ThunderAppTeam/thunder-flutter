import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/services/email_service.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/show_utils.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/features/auth/providers/auth_state_provider.dart';
import 'package:thunder/features/settings/views/settings_account_page.dart';
import 'package:thunder/features/settings/views/settings_info_page.dart';
import 'package:thunder/features/settings/views/settings_notification_page.dart';
import 'package:thunder/features/settings/widgets/settings_list_tile.dart';
import 'package:thunder/generated/l10n.dart';

class UserInfo {
  final String deviceModel;
  final String osVersion;
  final String appVersion;
  final String nickname;
  final String id;

  UserInfo({
    required this.deviceModel,
    required this.osVersion,
    required this.appVersion,
    required this.nickname,
    required this.id,
  });

  @override
  String toString() {
    return '- Device Model: $deviceModel\n- OS Version: $osVersion\n- App Version: $appVersion\n- Nickname: $nickname\n- ID: $id';
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showAlertDialog(
      context,
      title: S.of(context).settingsLogoutTitle,
      subtitle: S.of(context).settingsLogoutSubtitle,
      confirmText: S.of(context).settingsLogout,
    );
    if (confirmed == true && context.mounted) {
      await ref.read(authStateProvider.notifier).signOut();
      if (context.mounted) {
        ref.read(safeRouterProvider).goToWelcome(context);
      }
    }
  }

  void _onAccountTap(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsAccountPage()),
    );
  }

  void _onInfoTap(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsInfoPage()),
    );
  }

  void _onContactTap(BuildContext context, WidgetRef ref) async {
    final nickname = "구피닉네임999";
    try {
      await EmailService().sendSupportEmail(
        nickname: nickname,
        subject: S.of(context).contactSubject(nickname),
        bodyGuide: S.of(context).contactBodyGuide,
      );
    } catch (e) {
      if (context.mounted) {
        showCustomBottomSheet(context,
            title: "메일 앱을 실행할 수 없어요",
            subtitle:
                "회원님의 기기에 설치된 기본 메일 앱을 실행할 수 없는 상태에요. 문의사항을 아래 고객센터 이메일로 직접 문의해주세요.\n\n고객센터: thunderteam.korea@gmail.com");
      }
    }
  }

  void _onNotificationTap(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsNotificationPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).settingsTitle),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: Sizes.spacing8),
        child: Column(
          children: [
            SettingsListTile(
              icon: ThunderIcons.bell,
              title: S.of(context).settingsNotification,
              onTap: () => _onNotificationTap(context, ref),
            ),
            SettingsListTile(
              icon: ThunderIcons.user,
              title: S.of(context).settingsAccount,
              onTap: () => _onAccountTap(context, ref),
            ),
            SettingsListTile(
              icon: ThunderIcons.about,
              title: S.of(context).settingsInfo,
              onTap: () => _onInfoTap(context, ref),
            ),
            SettingsListTile(
              icon: ThunderIcons.mail,
              title: S.of(context).settingsContact,
              onTap: () => _onContactTap(context, ref),
            ),
            SettingsListTile(
              title: S.of(context).settingsLogout,
              onTap: () => _showLogoutDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}
