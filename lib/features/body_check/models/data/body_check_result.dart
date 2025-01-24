import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_check_result.freezed.dart';
part 'body_check_result.g.dart';

@freezed
class BodyCheckResult with _$BodyCheckResult {
  const factory BodyCheckResult({
    required int bodyPhotoId,
    required String imageUrl,
    required bool isReviewCompleted,
    required double totalScore,
    required double genderTopPercent,
    required DateTime createdAt,
  }) = _BodyCheckResult;

  factory BodyCheckResult.fromJson(Map<String, dynamic> json) =>
      _$BodyCheckResultFromJson(json);
}
