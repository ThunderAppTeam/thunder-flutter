import 'package:flutter/material.dart';
import 'package:thunder/core/constants/url_const.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/core/widgets/web_view_page.dart';
import 'package:thunder/features/settings/views/oss_licenses_page.dart';
import 'package:thunder/features/settings/widgets/settings_list_tile.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:thunder/generated/l10n.dart';

class SettingsInfoPage extends StatefulWidget {
  const SettingsInfoPage({super.key});

  @override
  State<SettingsInfoPage> createState() => _SettingsInfoPageState();
}

class _SettingsInfoPageState extends State<SettingsInfoPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  void _onTermsTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const WebViewPage(url: UrlConst.termsOfService)),
    );
  }

  void _onPrivacyPolicyTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WebViewPage(url: UrlConst.privacyPolicy),
      ),
    );
  }

  void _onOpenSourceLicenseTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OssLicensesPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).settingsInfo),
      body: Column(
        children: [
          SettingsListTile(
            title: S.of(context).settingsInfoTermsOfService,
            onTap: () => _onTermsTap(context),
            trailing: SettingsTrailing.icon(ThunderIcons.expandRight),
          ),
          SettingsListTile(
            title: S.of(context).settingsInfoPrivacyPolicy,
            onTap: () => _onPrivacyPolicyTap(context),
            trailing: SettingsTrailing.icon(ThunderIcons.expandRight),
          ),
          SettingsListTile(
            title: S.of(context).settingsInfoOpenSourceLicense,
            onTap: () => _onOpenSourceLicenseTap(context),
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
