import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thunder/features/notification/models/data/notification_data.dart';
part 'notification_state.freezed.dart';
// const factory NotificationData({
//   required bool reviewCompleteNotify,
//   required bool reviewRequestNotify,
//   required bool marketingAgreement,

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default(true) bool isReviewCompletNotify,
    @Default(true) bool isReviewRequestNotify,
    @Default(true) bool isMarketingAgreement,
  }) = _NotificationState;

  factory NotificationState.fromData(NotificationData data) =>
      NotificationState(
        isReviewCompletNotify: data.reviewCompleteNotify,
        isReviewRequestNotify: data.reviewRequestNotify,
        isMarketingAgreement: data.marketingAgreement,
      );
}
