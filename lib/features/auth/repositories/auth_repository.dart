import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thunder/core/constants/key_contsts.dart';
import 'package:thunder/core/errors/error_parser.dart';
import 'package:thunder/core/providers/dio_provider.dart';
import 'package:thunder/features/auth/models/data/sign_up_user.dart';

class AuthRepository {
  final FlutterSecureStorage _secureStorage;
  final Dio _dio;
  String? _accessToken;

  AuthRepository(this._secureStorage, this._dio);

  bool get isLoggedIn => _accessToken != null;
  // AuthToken
  Future<void> loadAuthData() async {
    _accessToken = await _secureStorage.read(key: KeyConsts.accessToken);
  }

  Future<void> saveAuthData(String accessToken) async {
    _accessToken = accessToken;
    await _secureStorage.write(key: KeyConsts.accessToken, value: accessToken);
  }

  Future<void> clearAuthData() async {
    _accessToken = null;
    await _secureStorage.delete(key: KeyConsts.accessToken);
  }

  /// 인증 코드 발송 (HTTP)
  Future<void> requestVerificationCode({
    required String phoneNumber,
    required String deviceId,
    required String countryCode,
  }) async {
    final path = '/v1/member/sms';
    try {
      final testMode = kDebugMode; // 디버그 모드일 때만 테스트 모드로 설정
      await _dio.post(path, data: {
        KeyConsts.deviceId: deviceId,
        KeyConsts.mobileCountry: countryCode,
        KeyConsts.mobileNumber: phoneNumber,
        KeyConsts.isTestMode: testMode,
      });
    } on DioException catch (e) {
      throw ErrorParser.parse(e);
    }
  }

  Future<bool> verifyCodeAndCheckExist({
    required String countryCode,
    required String phoneNumber,
    required String smsCode,
    required String deviceId,
  }) async {
    final path = '/v1/member/sms/verify';
    try {
      final response = await _dio.post(path, data: {
        KeyConsts.mobileCountry: countryCode,
        KeyConsts.mobileNumber: phoneNumber,
        KeyConsts.verificationCode: smsCode,
        KeyConsts.deviceId: deviceId,
      });
      final data = response.data[KeyConsts.data];
      final accessToken = data[KeyConsts.accessToken];
      if (accessToken != null) {
        await saveAuthData(accessToken);
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw ErrorParser.parse(e);
    } catch (e) {
      log('verifyCodeAndCheckExist error: $e');
      throw Exception('Verification process failed: $e');
    }
  }

  Future<bool> checkNicknameAvailability(String nickname) async {
    final path = '/v1/member/nickname/available';
    try {
      final response =
          await _dio.get(path, queryParameters: {KeyConsts.nickname: nickname});
      return response.statusCode == HttpStatus.ok;
    } on DioException catch (e) {
      throw ErrorParser.parse(e);
    }
  }

  Future<void> signUp(SignUpUser signUpUser) async {
    final path = '/v1/member/signup';
    try {
      final response = await _dio.post(path, data: signUpUser.toJson());
      final data = response.data[KeyConsts.data];
      final accessToken = data[KeyConsts.accessToken];
      if (accessToken != null) {
        await saveAuthData(accessToken);
      }
    } on DioException catch (e) {
      throw ErrorParser.parse(e);
    }
  }

  Future<void> signOut() async {
    await clearAuthData();
  }
}

final authRepoProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRepository(FlutterSecureStorage(), dio);
});
