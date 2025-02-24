import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thunder/features/notification/models/state/notification_state.dart';
part 'notification_data.freezed.dart';
part 'notification_data.g.dart';

@freezed
class NotificationData with _$NotificationData {
  const factory NotificationData({
    required bool reviewCompleteNotify,
    required bool reviewRequestNotify,
    required bool marketingAgreement,
  }) = _NotificationData;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  factory NotificationData.fromState(NotificationState state) =>
      NotificationData(
        reviewCompleteNotify: state.isReviewCompletNotify,
        reviewRequestNotify: state.isReviewRequestNotify,
        marketingAgreement: state.isMarketingAgreement,
      );
}
