import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceInfoNotifier extends StateNotifier<String?> {
  static const _prefsKeyDeviceId = 'device_id';

  DeviceInfoNotifier() : super(null);

  Future<void> _initDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_prefsKeyDeviceId);
    if (deviceId == null) {
      deviceId = await _generateDeviceId();
      await prefs.setString(_prefsKeyDeviceId, deviceId);
    }
    state = deviceId;
  }

  Future<String?> get deviceId async {
    if (state == null) {
      await _initDeviceId();
    }
    return state;
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
    return Uuid().v4();
  }
}

final deviceInfoProvider =
    StateNotifierProvider<DeviceInfoNotifier, String?>((ref) {
  return DeviceInfoNotifier();
});
