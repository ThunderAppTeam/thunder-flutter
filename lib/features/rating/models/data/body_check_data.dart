import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_check_data.freezed.dart';
part 'body_check_data.g.dart';

@freezed
class BodyCheckData with _$BodyCheckData {
  const factory BodyCheckData({
    required int bodyPhotoId,
    required String imageUrl,
    required int memberId,
    required String nickname,
    required int age,
  }) = _BodyCheckData;

  factory BodyCheckData.fromJson(Map<String, dynamic> json) =>
      _$BodyCheckDataFromJson(json);
}
