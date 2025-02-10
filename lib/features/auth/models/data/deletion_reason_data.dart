import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thunder/core/constants/key_contst.dart';

part 'deletion_reason_data.freezed.dart';
part 'deletion_reason_data.g.dart';

@freezed
class DeletionReasonData with _$DeletionReasonData {
  const factory DeletionReasonData({
    @JsonKey(name: KeyConst.memberDeletionReason) required String reason,
    @JsonKey(name: KeyConst.description) required String description,
  }) = _DeletionReasonData;

  factory DeletionReasonData.fromJson(Map<String, dynamic> json) =>
      _$DeletionReasonDataFromJson(json);
}
