import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:thunder/core/constants/app_const.dart';
import 'package:thunder/core/services/log_service.dart';

class EmailService {
  static Future<void> sendSupportEmail({
    required String nickname,
    required String userId,
    required String subject,
    required String bodyGuide,
  }) async {
    final userInfo = await _getUserInfo(nickname, userId);
    final body = '$bodyGuide\n\n\n-----\n$userInfo';

    final mail = Email(
      subject: subject,
      recipients: [AppConst.supportEmail],
      body: body,
    );

    try {
      await FlutterEmailSender.send(mail);
    } catch (e) {
      LogService.error(e.toString());
      rethrow;
    }
  }

  static Future<String> _getUserInfo(String nickname, String userId) async {
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
      LogService.error(e.toString());
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
- ID: $userId''';
  }

  static Future<DeviceInfo> _getAndroidDeviceInfo() async {
    final info = await DeviceInfoPlugin().androidInfo;
    return DeviceInfo(
      deviceModel: '${info.manufacturer} ${info.model}',
      osVersion: "Android ${info.version.release} (SDK ${info.version.sdkInt})",
    );
  }

  static Future<DeviceInfo> _getIOSDeviceInfo() async {
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
