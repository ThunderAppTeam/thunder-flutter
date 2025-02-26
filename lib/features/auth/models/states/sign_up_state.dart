import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(false) bool isError,
  }) = _SignUpState;
}

enum SignUpError {
  unknown;

  static SignUpError fromString(String errorCode) {
    switch (errorCode) {
      default:
        return SignUpError.unknown;
    }
  }
}
