import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:thunder/core/repositories/release_ui_repository.dart';

final releaseUiProvider = FutureProvider<bool>(
  (ref) async {
    final repository = ref.read(releaseUiRepositoryProvider);
    return repository.isReleaseUi(
      mobileOs: Platform.isIOS ? 'IOS' : 'ANDROID',
      appVersion: await PackageInfo.fromPlatform().then((info) => info.version),
    );
  },
);
