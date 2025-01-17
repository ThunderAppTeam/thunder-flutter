import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/core/widgets/dialog/custom_alert_dialog.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';
import 'package:thunder/generated/l10n.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: S.of(context).settingsLogoutTitle,
        subtitle: S.of(context).settingsLogoutSubtitle,
        confirmText: S.of(context).settingsLogout,
        cancelText: S.of(context).commonCancel,
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(authRepoProvider).signOut();
      if (context.mounted) {
        ref.read(safeRouterProvider).goToWelcome(context);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = getTextTheme(context);
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).settingsTitle),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: Sizes.spacing8,
        ),
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              vertical: Sizes.spacing16,
              horizontal: Sizes.spacing16,
            ),
            title: Text(
              S.of(context).settingsLogout,
              style: textTheme.textBody18,
            ),
            onTap: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
    );
  }
}
