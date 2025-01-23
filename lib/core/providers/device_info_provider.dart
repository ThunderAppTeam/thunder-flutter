import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:uuid/uuid.dart';

class DeviceInfoProvider {
  String? _cachedDeviceId;

  Future<String?> get deviceId async {
    _cachedDeviceId ??= await _loadOrGenerateDeviceId();
    return _cachedDeviceId;
  }

  Future<String> _loadOrGenerateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(KeyConst.deviceId);

    if (deviceId == null) {
      deviceId = await _generateDeviceId();
      await prefs.setString(KeyConst.deviceId, deviceId);
    }

    return deviceId;
  }

  Future<String> _generateDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Android ID
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? Uuid().v4(); // IDFV
    }

    return Uuid().v4(); // Default UUID for unsupported platforms
  }
}

final deviceInfoProvider = Provider<DeviceInfoProvider>((ref) {
  return DeviceInfoProvider();
});
