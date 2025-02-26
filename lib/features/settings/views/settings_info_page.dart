import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/features/settings/widgets/settings_list_tile.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:thunder/generated/l10n.dart';

class SettingsInfoPage extends ConsumerStatefulWidget {
  const SettingsInfoPage({super.key});

  @override
  ConsumerState<SettingsInfoPage> createState() => _SettingsInfoPageState();
}

class _SettingsInfoPageState extends ConsumerState<SettingsInfoPage> {
  String _version = '';
  late final SafeRouter _safeRouter;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _safeRouter = ref.read(safeRouterProvider);
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  void _onTermsTap() {
    _safeRouter.pushNamed(context, Routes.webview.terms.name);
  }

  void _onPrivacyPolicyTap() {
    _safeRouter.pushNamed(context, Routes.webview.privacy.name);
  }

  void _onOpenSourceLicenseTap() {
    _safeRouter.pushNamed(context, Routes.settings.ossLicenses.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).settingsInfo),
      body: Column(
        children: [
          SettingsListTile(
            title: S.of(context).settingsInfoTermsOfService,
            onTap: _onTermsTap,
            trailing: SettingsTrailing.icon(ThunderIcons.expandRight),
          ),
          SettingsListTile(
            title: S.of(context).settingsInfoPrivacyPolicy,
            onTap: _onPrivacyPolicyTap,
            trailing: SettingsTrailing.icon(ThunderIcons.expandRight),
          ),
          SettingsListTile(
            title: S.of(context).settingsInfoOpenSourceLicense,
            onTap: _onOpenSourceLicenseTap,
            trailing: SettingsTrailing.icon(ThunderIcons.expandRight),
          ),
          SettingsListTile(
            title: S.of(context).settingsInfoAppVersion,
            trailing: SettingsTrailing.text(_version),
          ),
        ],
      ),
    );
  }
}
