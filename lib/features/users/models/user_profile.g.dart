// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      uid: json['uid'] as String,
      phoneNumber: json['phoneNumber'] as String,
      nickname: json['nickname'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      birthdate:
          const TimestampConverter().fromJson(json['birthdate'] as Timestamp),
      marketingAgreed: json['marketingAgreed'] as bool,
      createdAt: (json['createdAt'] as num).toInt(),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'phoneNumber': instance.phoneNumber,
      'nickname': instance.nickname,
      'gender': _$GenderEnumMap[instance.gender]!,
      'birthdate': const TimestampConverter().toJson(instance.birthdate),
      'marketingAgreed': instance.marketingAgreed,
      'createdAt': instance.createdAt,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};
