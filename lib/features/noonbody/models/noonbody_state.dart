import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thunder/core/enums/gender.dart';

part 'noonbody_state.freezed.dart';

@freezed
class NoonbodyState with _$NoonbodyState {
  const factory NoonbodyState({
    @Default(0) double progress,
    @Default(0) double currentScore,
    @Default(false) bool isUploading,
    @Default(false) bool isFinished,
    @Default(Gender.male) Gender gender,
    @Default(0) int age,
    @Default(0) double genderPercent, // 성별 내에서의 상위%
    @Default(0) double percent, // 전체 상위%
  }) = _NoonbodyState;
}
