import 'package:freezed_annotation/freezed_annotation.dart';

part 'flag_reason_data.freezed.dart';
part 'flag_reason_data.g.dart';

@freezed
class FlagReasonData with _$FlagReasonData {
  const factory FlagReasonData({
    @JsonKey(name: "flagReason") required String flagReason,
    @JsonKey(name: "description") required String description,
  }) = _FlagReasonData;

  factory FlagReasonData.fromJson(Map<String, dynamic> json) =>
      _$FlagReasonDataFromJson(json);
}
