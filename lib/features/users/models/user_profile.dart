import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/core/utils/timestamp_converter.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String phoneNumber,
    required String nickname,
    required Gender gender,
    @TimestampConverter() required DateTime birthdate,
    required bool marketingAgreed,
    required int createdAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
