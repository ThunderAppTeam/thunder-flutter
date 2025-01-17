import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/time_consts.dart';
import 'package:thunder/core/utils/info_utils.dart';
import 'package:thunder/features/auth/providers/phone_auth_provider.dart';
import 'package:thunder/features/onboarding/providers/onboarding_provider.dart';

class VerificationTimerState {
  final bool isInitial;
  final bool canSend;
  final bool canVerify;
  final int remainingSeconds;

  VerificationTimerState({
    this.isInitial = true,
    this.canSend = true,
    this.canVerify = true,
    this.remainingSeconds = TimeConsts.verificationTimeLimit,
  });

  VerificationTimerState copyWith({
    bool? isInitial,
    bool? canSend,
    bool? canVerify,
    int? remainingSeconds,
  }) {
    return VerificationTimerState(
      isInitial: isInitial ?? this.isInitial,
      canSend: canSend ?? this.canSend,
      canVerify: canVerify ?? this.canVerify,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }
}

class VerificationTimerController
    extends StateNotifier<VerificationTimerState> {
  final Ref _ref;
  Timer? _timer;
  final int _timeLimit = TimeConsts.verificationTimeLimit;
  final int _coolDownSeconds = TimeConsts.verificationCoolDown;
  int _remainingSeconds = TimeConsts.verificationTimeLimit;

  VerificationTimerController(this._ref) : super(VerificationTimerState());

  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = _timeLimit;
    _updateTimerState();
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (_remainingSeconds == 0) {
          // 시간 초과 시 인증 버튼 비활성화
          timer.cancel();
          state = state.copyWith(canVerify: false);
        } else {
          _remainingSeconds--;
          _updateTimerState();
        }
      },
    );
  }

  void _updateTimerState() {
    state = state.copyWith(
      remainingSeconds: _remainingSeconds,
      canSend: _remainingSeconds <= (_timeLimit - _coolDownSeconds),
    );
  }

  void _sendVerificationCode() async {
    if (state.canSend) {
      state = state.copyWith(canSend: false, canVerify: true);
      final phoneNumber = _ref.read(onboardingProvider).phoneNumber!;
      final countryCode = getCountryCode();
      await _ref.read(phoneAuthProvider.notifier).sendVerificationCode(
            phoneNumber: phoneNumber,
            countryCode: countryCode,
          );
      _startTimer();
    }
  }

  void init() {
    // 첫 화면 진입 시 인증 코드 발송
    if (state.isInitial) {
      state = state.copyWith(isInitial: false);
      _sendVerificationCode();
    }
  }

  void resendVerificationCode() {
    // 재발송 버튼 클릭 시 인증 코드 발송
    _sendVerificationCode();
  }

  void verifyCode(String smsCode) async {
    state = state.copyWith(canVerify: false);
    final phoneNumber = _ref.read(onboardingProvider).phoneNumber!;
    final countryCode = getCountryCode();
    _ref.read(phoneAuthProvider.notifier).veryfyCode(
          smsCode: smsCode,
          phoneNumber: phoneNumber,
          countryCode: countryCode,
        );
    // 1초 뒤에 canVerify를 true로 변경
    await Future.delayed(TimeConsts.onboardingButtonCoolDown);
    state = state.copyWith(canVerify: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final verificationTimerProvider =
    StateNotifierProvider<VerificationTimerController, VerificationTimerState>(
  (ref) => VerificationTimerController(ref),
);
