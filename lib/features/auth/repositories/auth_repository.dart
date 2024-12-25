import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/auth/models/auth_state.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => currentUser != null;

  /// 인증 코드 발송
  ///
  /// `onAutoVerified`: sms 코드를 받아서 자동 가입 UI 처리
  /// `onFailed`: 인증 실패 시 처리 로직
  /// `onCodeSent`: 인증 코드 발송 완료 시 처리 로직
  Future<void> sendVerificationCode({
    required String phoneNumber,
    required void Function(String? smsCode) onAutoVerified,
    required void Function(AuthFailureReason reason) onFailed,
    required void Function(String verificationId) onCodeSent,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) async {
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        await _auth.signInWithCredential(phoneAuthCredential);
        onAutoVerified(phoneAuthCredential.smsCode); // 자동 가입 완료 후 처리 로직
      },
      verificationFailed: (error) {
        // 잘못된 전화번호, 프로젝트 SMS 할당량 초과된 경우
        log('Error Code: ${error.code}');
        log('Error Message: ${error.message}');
        onFailed(_mapFirebaseAuthException(error));
      },
      codeSent: (verificationId, resendToken) {
        // resendToken은 ANDROID ONLY!, IOS: NULL
        // 올바른 SMS 코드를 입력할 것을 알리는 메세지
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        // 자동 코드 확인을 지원하는 Android 기기에서 특정 기간 내에 SMS 코드를 입력하지 않은 경우
        // 따로 처리 로직 없음. (사용자가 입력한 코드로 확인 할 것임, 그리고 2분 지나면 어차피 타임아웃 처리됨)
      },
      timeout: const Duration(seconds: 10),
    );
  }

  AuthFailureReason _mapFirebaseAuthException(FirebaseAuthException error) {
    log('Error Code: ${error.code}');
    return switch (error.code) {
      AuthExceptionCode.webContextCancelled =>
        AuthFailureReason.reCaptchaVerificationFailed,
      'invalid-phone-number' => AuthFailureReason.invalidPhoneNumber,
      'quota-exceeded' => AuthFailureReason.quotaExceeded,
      _ => AuthFailureReason.unknown,
    };
  }

  Future<UserCredential> verifyCode(
    String verificationId,
    String smsCode,
  ) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

final authRepoProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});
