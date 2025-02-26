import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_check_preview_data.freezed.dart';
part 'body_check_preview_data.g.dart';

@freezed
class BodyCheckPreviewData with _$BodyCheckPreviewData {
  const factory BodyCheckPreviewData({
    required int bodyPhotoId,
    required String imageUrl,
    required int reviewCount,
    required double reviewScore,
    required DateTime createdAt,
  }) = _BodyCheckPreviewData;

  factory BodyCheckPreviewData.fromJson(Map<String, dynamic> json) =>
      _$BodyCheckPreviewDataFromJson(json);
}
