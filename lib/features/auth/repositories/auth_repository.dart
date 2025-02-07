import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/network/dio_options.dart';
import 'package:thunder/core/network/dio_provider.dart';
import 'package:thunder/core/network/repository/base_repository.dart';
import 'package:thunder/core/providers/token_provider.dart';
import 'package:thunder/core/services/log_service.dart';
import 'package:thunder/features/auth/models/data/sign_up_user.dart';

class AuthRepository with BaseRepository {
  @override
  final Dio dio;

  final TokenProvider _tokenProvider;

  AuthRepository(this.dio, this._tokenProvider);

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
    final testMode = kDebugMode; // 디버그 모드일 때만 테스트 모드로 설정
    await post(path, data: {
      KeyConst.deviceId: deviceId,
      KeyConst.mobileCountry: countryCode,
      KeyConst.mobileNumber: phoneNumber,
      KeyConst.isTestMode: testMode,
    });
  }

  Future<int?> verifyCodeAndCheckExist({
    required String countryCode,
    required String phoneNumber,
    required String smsCode,
    required String deviceId,
  }) async {
    final path = '/v1/member/sms/verify';
    try {
      final data = await post(path, data: {
        KeyConst.mobileCountry: countryCode,
        KeyConst.mobileNumber: phoneNumber,
        KeyConst.verificationCode: smsCode,
        KeyConst.deviceId: deviceId,
      });
      final accessToken = data[KeyConst.accessToken];
      final memberId = data[KeyConst.memberId];
      if (accessToken != null && memberId != null) {
        await _tokenProvider.setToken(accessToken);
        return memberId;
      }
      return null;
    } catch (e) {
      LogService.error('Verification process failed: $e');
      throw Exception('Verification process failed: $e');
    }
  }

  Future<void> checkNicknameAvailability(String nickname) async {
    final path = '/v1/member/nickname/available';
    await get(path, queryParameters: {KeyConst.nickname: nickname});
  }

  Future<int> signUp(SignUpUser signUpUser) async {
    final path = '/v1/member/signup';
    try {
      final data = await post(path, data: signUpUser.toJson());
      final accessToken = data[KeyConst.accessToken];
      final memberId = data[KeyConst.memberId];
      await _tokenProvider.setToken(accessToken);
      return memberId;
    } catch (e) {
      LogService.error('Failed to sign up: $e');
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getDeletionReasons() async {
    final path = '/v1/member/deletion-reason';
    final data = await get(path, options: DioOptions.tokenOptions);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> deleteAccount(String reason) async {
    // final path = '/v1/member/deletion';
    // TODO: api 개발 이후에 구현
  }
}

final authRepoProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  final tokenService = ref.read(tokenProvider);
  return AuthRepository(dio, tokenService);
});
