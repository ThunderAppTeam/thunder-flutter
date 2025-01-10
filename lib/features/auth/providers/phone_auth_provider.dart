import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/auth/models/domain/phone_auth_state.dart';
import 'package:thunder/core/providers/device_info_provider.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

class PhoneAuthNotifier extends StateNotifier<PhoneAuthState> {
  final AuthRepository _repository;
  final DeviceInfoNotifier _deviceInfoNotifier;

  PhoneAuthNotifier(this._repository, this._deviceInfoNotifier)
      : super(PhoneAuthState());

  Future<void> sendVerificationCode({
    required String phoneNumber,
    required String countryCode,
  }) async {
    state = state.copyWith(isCodeSending: true, error: null);
    final deviceId = await _deviceInfoNotifier.deviceId;
    if (deviceId == null) {
      log('deviceId is null after initialization');
      state = state.copyWith(error: PhoneAuthError.unknown);
      return;
    }
    try {
      await _repository.requestVerificationCode(
        phoneNumber: phoneNumber,
        deviceId: deviceId,
        countryCode: countryCode,
      );
      state = state.copyWith(isCodeSending: false);
    } on PhoneAuthError catch (e) {
      state = state.copyWith(isCodeSending: false, error: e);
      if (e == PhoneAuthError.tooManyMobileVerification) {
        state = state.copyWith(isTooManyMobileVerification: true);
      }
    }
  }

  Future<void> veryfyCode({
    required String smsCode,
    required String phoneNumber,
    required String countryCode,
  }) async {
    state =
        state.copyWith(isCodeVerifying: true, isVerified: false, error: null);
    final deviceId = await _deviceInfoNotifier.deviceId;
    if (deviceId == null) {
      log('deviceId is null after initialization');
      state = state.copyWith(error: PhoneAuthError.unknown);
      return;
    }
    try {
      await _repository.verifyCode(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        smsCode: smsCode,
        deviceId: deviceId,
      );
      state = state.copyWith(isCodeVerifying: false, isVerified: true);
    } on PhoneAuthError catch (e) {
      state = state.copyWith(isCodeVerifying: false, error: e);
    }
  }
}

final phoneAuthProvider =
    StateNotifierProvider<PhoneAuthNotifier, PhoneAuthState>((ref) {
  return PhoneAuthNotifier(
    ref.read(authRepoProvider),
    ref.read(deviceInfoProvider.notifier),
  );
});