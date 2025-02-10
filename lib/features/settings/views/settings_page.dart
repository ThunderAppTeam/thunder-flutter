import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/app_const.dart';
import 'package:thunder/core/constants/value_const.dart';
import 'package:thunder/core/services/email_service.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/show_utils.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/features/auth/providers/auth_state_provider.dart';
import 'package:thunder/features/member/view_models/member_view_model.dart';
import 'package:thunder/features/settings/widgets/settings_list_tile.dart';
import 'package:thunder/generated/l10n.dart';

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
    ref
        .read(safeRouterProvider)
        .pushNamed(context, Routes.settings.account.name);
  }

  void _onInfoTap(BuildContext context, WidgetRef ref) {
    ref.read(safeRouterProvider).pushNamed(context, Routes.settings.info.name);
  }

  void _onContactTap(
      BuildContext context, String nickname, String memberUuid) async {
    try {
      await EmailService.sendSupportEmail(
        nickname: nickname,
        userId: memberUuid,
        subject: S.of(context).contactSubject(nickname),
        bodyGuide: S.of(context).contactBodyGuide,
      );
    } catch (e) {
      if (context.mounted) {
        showCustomBottomSheet(context,
            title: S.of(context).contactErrorTitle,
            subtitle:
                S.of(context).contactErrorSubtitle(AppConst.supportEmail));
      }
    }
  }

  void _onNotificationTap(BuildContext context, WidgetRef ref) {
    ref
        .read(safeRouterProvider)
        .pushNamed(context, Routes.settings.notification.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberData = ref.watch(memberDataProvider);
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
              onTap: () => _onContactTap(
                context,
                memberData.valueOrNull?.nickname ?? ValueConst.unknown,
                memberData.valueOrNull?.memberUuid ?? ValueConst.unknown,
              ),
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
