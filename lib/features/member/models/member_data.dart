import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_data.freezed.dart';
part 'member_data.g.dart';

@freezed
class MemberData with _$MemberData {
  const factory MemberData({
    required String memberUuid,
    required String nickname,
    required String mobileNumber,
    required DateTime registeredAt,
  }) = _MemberData;

  factory MemberData.fromJson(Map<String, dynamic> json) =>
      _$MemberDataFromJson(json);
}
