import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/providers/dio_provider.dart';
import 'package:thunder/features/auth/models/phone_auth_state.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final Dio _dio;

  AuthRepository(this._auth, this._dio);

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => currentUser != null;

  /// 인증 코드 발송 (HTTP)
  Future<void> requestVerificationCode({
    required String phoneNumber,
    required String deviceId,
    required String countryCode,
  }) async {
    final path = '/v1/member/sms';
    try {
      var testMode = false;
      await _dio.post(path, data: {
        'deviceId': deviceId,
        'mobileCountry': countryCode,
        'mobileNumber': phoneNumber,
        'isTestMode': testMode,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        final errorCode = e.response?.data['errorCode'] ?? '';
        throw PhoneAuthError.fromString(errorCode);
      }
      throw PhoneAuthError.unknown;
    }
  }

  Future<void> verifyCode({
    required String countryCode,
    required String phoneNumber,
    required String smsCode,
  }) async {
    final path = '/v1/member/sms/verify';
    try {
      await _dio.post(path, data: {
        'mobileCountry': countryCode,
        'mobileNumber': phoneNumber,
        'verificationCode': smsCode,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        final errorCode = e.response?.data['errorCode'] ?? '';
        throw PhoneAuthError.fromString(errorCode);
      }
      throw PhoneAuthError.unknown;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

final authRepoProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRepository(FirebaseAuth.instance, dio);
});
