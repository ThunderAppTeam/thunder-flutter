import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_property_data.freezed.dart';
part 'user_property_data.g.dart';

@freezed
class UserPropertyData with _$UserPropertyData {
  const factory UserPropertyData({
    required String gender,
    required int age,
    required String memberUuid,
  }) = _UserPropertyData;

  factory UserPropertyData.fromJson(Map<String, dynamic> json) =>
      _$UserPropertyDataFromJson(json);
}
