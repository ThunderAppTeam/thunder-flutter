import 'dart:async';
import 'package:extended_image/extended_image.dart' as extended_image;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/network/dio_options.dart';
import 'package:thunder/core/network/dio_provider.dart';
import 'package:thunder/core/network/repository/base_repository.dart';
import 'package:thunder/core/providers/token_provider.dart';
import 'package:thunder/core/services/log_service.dart';
import 'package:thunder/features/auth/models/data/sign_up_user.dart';

class AuthRepository extends BaseRepository {
  final TokenProvider _tokenProvider;

  AuthRepository(super.dio, this._tokenProvider);

  bool get isLoggedIn => _tokenProvider.token != null;

  String? get accessToken => _tokenProvider.token;
  // AuthToken
  Future<void> loadAuthData() async {
    await _tokenProvider.initialize();
  }

  Future<void> signOut() async {
    try {
      await put('/v1/member/logout', options: DioOptions.tokenOptions);
    } catch (e) {
      LogService.error('Logout API failed: $e');
    } finally {
      await _tokenProvider.clearToken();
      await extended_image.clearDiskCachedImages();
    }
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

  Future<String?> verifyCodeAndCheckExist({
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
      final memberUuid = data[KeyConst.memberUuid];
      if (accessToken != null && memberUuid != null) {
        await _tokenProvider.setToken(accessToken);
        return memberUuid;
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

  Future<Map<String, dynamic>> signUp(SignUpUser signUpUser) async {
    final path = '/v1/member/signup';
    try {
      final data = await post(path, data: signUpUser.toJson());
      final accessToken = data[KeyConst.accessToken];
      await _tokenProvider.setToken(accessToken);
      return data;
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

  Future<void> deleteAccount(String reason, String? otherReason) async {
    final path = '/v1/member/deletion';
    await post(path, options: DioOptions.tokenOptions, data: {
      KeyConst.deletionReason: reason,
      if (otherReason != null) KeyConst.otherReason: otherReason,
    });
    await _tokenProvider.clearToken();
    await extended_image.clearDiskCachedImages();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  final tokenService = ref.read(tokenProvider);
  return AuthRepository(dio, tokenService);
});
