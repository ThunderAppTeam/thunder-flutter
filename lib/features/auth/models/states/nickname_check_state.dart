import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thunder/core/errors/server_error.dart';

part 'nickname_check_state.freezed.dart';

@freezed
class NicknameCheckState with _$NicknameCheckState {
  const factory NicknameCheckState({
    @Default(false) bool isLoading,
    @Default(false) bool isAvailable,
    NicknameCheckError? error,
  }) = _NicknameCheckState;
}

enum NicknameCheckError {
  duplicated,
  unknown;

  static NicknameCheckError fromServerError(ServerError error) {
    switch (error) {
      case ServerError.nicknameDuplicated:
        return NicknameCheckError.duplicated;
      default:
        return NicknameCheckError.unknown;
    }
  }
}
