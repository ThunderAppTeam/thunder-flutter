import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:thunder/core/constants/app_const.dart';

class EmailService {
  Future<void> sendSupportEmail({
    required String nickname,
    required String subject,
    required String bodyGuide,
  }) async {
    final userInfo = await _getUserInfo(nickname);
    final body = '$bodyGuide\n\n\n-----\n$userInfo';

    final mail = Email(
      subject: subject,
      recipients: [AppConst.supportEmail],
      body: body,
    );

    try {
      await FlutterEmailSender.send(mail);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<String> _getUserInfo(String nickname) async {
    DeviceInfo deviceInfo;
    try {
      if (kIsWeb) {
        throw PlatformException(
          code: 'UnsupportedPlatform',
          message: 'Web platform isn\'t supported',
        );
      } else {
        deviceInfo = switch (defaultTargetPlatform) {
          TargetPlatform.android => await _getAndroidDeviceInfo(),
          TargetPlatform.iOS => await _getIOSDeviceInfo(),
          _ => throw PlatformException(
              code: 'UnsupportedPlatform',
              message: 'Unsupported platform',
            ),
        };
      }
    } on PlatformException catch (e) {
      log(e.toString());
      deviceInfo = DeviceInfo(
        deviceModel: 'Unknown',
        osVersion: 'Unknown',
      );
    }
    final appVersion = (await PackageInfo.fromPlatform()).version;

    return '''
- Device Model: ${deviceInfo.deviceModel}
- OS Version: ${deviceInfo.osVersion}
- App Version: $appVersion
- Nickname: $nickname
- ID: ???''';
  }

  Future<DeviceInfo> _getAndroidDeviceInfo() async {
    final info = await DeviceInfoPlugin().androidInfo;
    return DeviceInfo(
      deviceModel: '${info.manufacturer} ${info.model}',
      osVersion: "Android ${info.version.release} (SDK ${info.version.sdkInt})",
    );
  }

  Future<DeviceInfo> _getIOSDeviceInfo() async {
    final info = await DeviceInfoPlugin().iosInfo;
    return DeviceInfo(
      deviceModel: info.modelName,
      osVersion: '${info.systemName} ${info.systemVersion}',
    );
  }
}

class DeviceInfo {
  final String deviceModel;
  final String osVersion;

  DeviceInfo({
    required this.deviceModel,
    required this.osVersion,
  });
}
