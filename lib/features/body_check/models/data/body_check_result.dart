import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thunder/core/enums/gender.dart';

part 'body_check_result.freezed.dart';
part 'body_check_result.g.dart';

@freezed
class BodyCheckResult with _$BodyCheckResult {
  const factory BodyCheckResult({
    required int bodyPhotoId,
    required String imageUrl,
    required bool isReviewCompleted,
    required int reviewCount,
    required double progressRate,
    required Gender gender,
    required double reviewScore,
    required double genderTopRate,
    required DateTime createdAt,
  }) = _BodyCheckResult;

  factory BodyCheckResult.fromJson(Map<String, dynamic> json) =>
      _$BodyCheckResultFromJson(json);
}
