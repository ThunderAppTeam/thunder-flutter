import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contsts.dart';
import 'package:thunder/core/errors/error_parser.dart';
import 'package:thunder/core/providers/dio_provider.dart';
import 'package:thunder/core/providers/token_provider.dart';
import 'package:thunder/features/auth/models/data/sign_up_user.dart';

class AuthRepository {
  final Dio _dio;
  final TokenProvider _tokenProvider;

  AuthRepository(this._dio, this._tokenProvider);

  bool get isLoggedIn => _tokenProvider.token != null;

  String? get accessToken => _tokenProvider.token;
  // AuthToken
  Future<void> loadAuthData() async {
    await _tokenProvider.initialize();
  }

  Future<void> signOut() async {
    await _tokenProvider.clearToken();
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
      throw ErrorParser.parseDio(e);
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
        await _tokenProvider.setToken(accessToken);
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw ErrorParser.parseDio(e);
    } catch (e) {
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
      throw ErrorParser.parseDio(e);
    }
  }

  Future<void> signUp(SignUpUser signUpUser) async {
    final path = '/v1/member/signup';
    try {
      final response = await _dio.post(path, data: signUpUser.toJson());
      final data = response.data[KeyConsts.data];
      final accessToken = data[KeyConsts.accessToken];
      if (accessToken != null) {
        await _tokenProvider.setToken(accessToken);
      }
    } on DioException catch (e) {
      throw ErrorParser.parseDio(e);
    }
  }
}

final authRepoProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  final tokenService = ref.read(tokenProvider);
  return AuthRepository(dio, tokenService);
});
