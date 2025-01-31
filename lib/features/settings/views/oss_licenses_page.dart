import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/core/widgets/web_view_page.dart';
import 'package:thunder/features/settings/widgets/settings_list_tile.dart';
import 'package:thunder/generated/l10n.dart';
import 'package:thunder/oss_licenses.dart';

class OssLicensesPage extends StatelessWidget {
  const OssLicensesPage({super.key});

  static Future<List<Package>> loadLicenses() async {
    // merging non-dart dependency list using LicenseRegistry.
    final lm = <String, List<String>>{};
    await for (var l in LicenseRegistry.licenses) {
      for (var p in l.packages) {
        final lp = lm.putIfAbsent(p, () => []);
        lp.addAll(l.paragraphs.map((p) => p.text));
      }
    }
    final licenses = allDependencies.toList();
    for (var key in lm.keys) {
      licenses.add(Package(
        name: key,
        description: '',
        authors: [],
        version: '',
        license: lm[key]!.join('\n\n'),
        isMarkdown: false,
        isSdk: false,
        dependencies: [],
      ));
    }
    return licenses..sort((a, b) => a.name.compareTo(b.name));
  }

  static final _licenses = loadLicenses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            CustomAppBar(title: S.of(context).settingsInfoOpenSourceLicense),
        body: FutureBuilder<List<Package>>(
            future: _licenses,
            initialData: const [],
            builder: (context, snapshot) {
              return ListView.separated(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final package = snapshot.data![index];
                    return SettingsListTile(
                      title: '${package.name} ${package.version}',
                      trailing: SettingsTrailing.icon(ThunderIcons.expandRight),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              MiscOssLicenseSingle(package: package),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                        height: 0,
                        color: ColorName.darkLabel2,
                        thickness: 0.5,
                      ));
            }));
  }
}

class MiscOssLicenseSingle extends StatelessWidget {
  final Package package;

  const MiscOssLicenseSingle({super.key, required this.package});

  String _bodyText() {
    return package.license!.split('\n').map((line) {
      if (line.startsWith('//')) line = line.substring(2);
      line = line.trim();
      return line;
    }).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Scaffold(
      appBar: CustomAppBar(title: '${package.name} ${package.version}'),
      body: Container(
        color: ColorName.darkBackground2,
        child: ListView(
          children: <Widget>[
            if (package.description.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.only(
                      top: Sizes.spacing12,
                      left: Sizes.spacing12,
                      right: Sizes.spacing12),
                  child:
                      Text(package.description, style: textTheme.textBody12)),
            if (package.homepage != null)
              Padding(
                  padding: const EdgeInsets.only(
                    top: Sizes.spacing12,
                    left: Sizes.spacing12,
                    right: Sizes.spacing12,
                  ),
                  child: InkWell(
                    child: Text(
                      package.homepage!,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              WebViewPage(url: package.homepage!),
                        ),
                      );
                    },
                  )),
            if (package.description.isNotEmpty || package.homepage != null)
              const Divider(),
            Padding(
              padding: const EdgeInsets.only(
                top: Sizes.spacing12,
                left: Sizes.spacing12,
                right: Sizes.spacing12,
              ),
              child: Text(
                _bodyText(),
                style:
                    textTheme.textBody14.copyWith(height: Sizes.fontHeight14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
