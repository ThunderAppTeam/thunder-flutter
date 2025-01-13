import 'package:freezed_annotation/freezed_annotation.dart';
part 'sign_up_user.freezed.dart';
part 'sign_up_user.g.dart';

@freezed
class SignUpUser with _$SignUpUser {
  const factory SignUpUser({
    required String nickname,
    required String mobileCountry,
    required String mobileNumber,
    required String gender,
    required String birthDay,
    required String countryCode,
    required bool marketingAgreement,
  }) = _SignUpUser;

  factory SignUpUser.fromJson(Map<String, dynamic> json) =>
      _$SignUpUserFromJson(json);
}
