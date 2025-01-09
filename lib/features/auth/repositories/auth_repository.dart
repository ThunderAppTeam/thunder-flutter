import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/api_contst.dart';
import 'package:thunder/core/providers/dio_provider.dart';
import 'package:thunder/features/auth/models/nickname_check_state.dart';
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
        ApiKeys.deviceId: deviceId,
        ApiKeys.mobileCountry: countryCode,
        ApiKeys.mobileNumber: phoneNumber,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        final errorCode = e.response?.data[ApiKeys.errorCode] ?? '';
        throw PhoneAuthError.fromString(errorCode);
      }
      throw PhoneAuthError.unknown;
    }
  }

  Future<void> verifyCode({
    required String countryCode,
    required String phoneNumber,
    required String smsCode,
    required String deviceId,
  }) async {
    final path = '/v1/member/sms/verify';
    try {
      await _dio.post(path, data: {
        ApiKeys.mobileCountry: countryCode,
        ApiKeys.mobileNumber: phoneNumber,
        ApiKeys.verificationCode: smsCode,
        ApiKeys.deviceId: deviceId,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        final errorCode = e.response?.data[ApiKeys.errorCode] ?? '';
        throw PhoneAuthError.fromString(errorCode);
      }
      throw PhoneAuthError.unknown;
    }
  }

  Future<bool> checkNicknameAvailability(String nickname) async {
    final path = '/v1/member/nickname/available';
    try {
      final response =
          await _dio.get(path, queryParameters: {ApiKeys.nickname: nickname});
      return response.statusCode == HttpStatus.ok;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorCode = e.response?.data[ApiKeys.errorCode] ?? '';
        throw NicknameCheckError.fromString(errorCode);
      }
      throw NicknameCheckError.unknown;
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
