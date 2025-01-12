import 'dart:async';
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
  String? _userId;

  AuthRepository(this._secureStorage, this._dio);

  bool get isLoggedIn => _accessToken != null;

  String? get userId => _userId;
  // AuthToken
  Future<void> loadAuthData() async {
    _accessToken = await _secureStorage.read(key: KeyConsts.authToken);
    _userId = await _secureStorage.read(key: KeyConsts.userId);
  }

  Future<void> saveAuthData(String accessToken, String userId) async {
    _accessToken = accessToken;
    _userId = userId;
    await _secureStorage.write(key: KeyConsts.authToken, value: accessToken);
    await _secureStorage.write(key: KeyConsts.userId, value: userId);
  }

  Future<void> clearAuthData() async {
    _accessToken = null;
    _userId = null;
    await _secureStorage.delete(key: KeyConsts.authToken);
    await _secureStorage.delete(key: KeyConsts.userId);
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
      ErrorParser.parseAndThrow(e);
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
        KeyConsts.mobileCountry: countryCode,
        KeyConsts.mobileNumber: phoneNumber,
        KeyConsts.verificationCode: smsCode,
        KeyConsts.deviceId: deviceId,
      });
    } on DioException catch (e) {
      ErrorParser.parseAndThrow(e);
    }
  }

  Future<bool> checkNicknameAvailability(String nickname) async {
    final path = '/v1/member/nickname/available';
    try {
      final response =
          await _dio.get(path, queryParameters: {KeyConsts.nickname: nickname});
      return response.statusCode == HttpStatus.ok;
    } on DioException catch (e) {
      ErrorParser.parseAndThrow(e);
      return false;
    }
  }

  Future<void> signUp(SignUpUser signUpUser) async {
    final path = '/v1/member/signup';
    try {
      final response = await _dio.post(path, data: signUpUser.toJson());
      final memberId =
          response.data[KeyConsts.data][KeyConsts.memberId] ?? '1234';
      await saveAuthData(memberId, memberId); // TODO: 토큰 발급 로직 추가
    } on DioException catch (e) {
      ErrorParser.parseAndThrow(e);
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
