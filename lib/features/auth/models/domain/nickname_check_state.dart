import 'package:freezed_annotation/freezed_annotation.dart';

part 'nickname_check_state.freezed.dart';

@freezed
class NicknameCheckState with _$NicknameCheckState {
  const factory NicknameCheckState({
    @Default(false) bool isLoading,
    @Default(false) bool isAvailable,
    NicknameCheckError? error,
  }) = _NicknameCheckState;
}

class NicknameCheckExceptionCode {
  static const nicknameDuplicated = 'NICKNAME_DUPLICATED';
}

enum NicknameCheckError {
  duplicated,
  unknown;

  static NicknameCheckError fromString(String errorCode) {
    switch (errorCode) {
      case NicknameCheckExceptionCode.nicknameDuplicated:
        return NicknameCheckError.duplicated;
      default:
        return NicknameCheckError.unknown;
    }
  }
}
