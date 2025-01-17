import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/errors/server_error.dart';
import 'package:thunder/features/auth/models/states/phone_auth_state.dart';
import 'package:thunder/core/providers/device_info_provider.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

class PhoneAuthNotifier extends StateNotifier<PhoneAuthState> {
  final AuthRepository _repository;
  final DeviceInfoProvider _deviceInfoProvider;

  PhoneAuthNotifier(this._repository, this._deviceInfoProvider)
      : super(PhoneAuthState());

  Future<void> sendVerificationCode({
    required String phoneNumber,
    required String countryCode,
  }) async {
    state = state.copyWith(isCodeSending: true, error: null);
    final deviceId = await _deviceInfoProvider.deviceId;
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
    } on ServerError catch (e) {
      final error = PhoneAuthError.fromServerError(e);
      state = state.copyWith(isCodeSending: false, error: error);
      if (e == ServerError.tooManyMobileVerification) {
        state = state.copyWith(isTooManyMobileVerification: true);
      }
    } catch (e) {
      state =
          state.copyWith(isCodeSending: false, error: PhoneAuthError.unknown);
    }
  }

  Future<bool> veryfyCode({
    required String smsCode,
    required String phoneNumber,
    required String countryCode,
  }) async {
    state =
        state.copyWith(isCodeVerifying: true, isVerified: false, error: null);
    final deviceId = await _deviceInfoProvider.deviceId;
    if (deviceId == null) {
      log('deviceId is null after initialization');
      state = state.copyWith(error: PhoneAuthError.unknown);
      return false;
    }
    try {
      final isExist = await _repository.verifyCodeAndCheckExist(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        smsCode: smsCode,
        deviceId: deviceId,
      );
      state = state.copyWith(
        isCodeVerifying: false,
        isVerified: true,
        isExistUser: isExist,
      );
      return true;
    } on ServerError catch (e) {
      final error = PhoneAuthError.fromServerError(e);
      state = state.copyWith(isCodeVerifying: false, error: error);
    } catch (e) {
      state =
          state.copyWith(isCodeVerifying: false, error: PhoneAuthError.unknown);
    }
    return false;
  }
}

final phoneAuthProvider =
    StateNotifierProvider.autoDispose<PhoneAuthNotifier, PhoneAuthState>((ref) {
  return PhoneAuthNotifier(
    ref.read(authRepoProvider),
    ref.read(deviceInfoProvider),
  );
});
