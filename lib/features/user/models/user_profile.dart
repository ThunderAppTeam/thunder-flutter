import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    String? phoneNumber,
    String? nickname,
    DateTime? birthday,
    String? gender,
  }) = _UserProfile;
}
