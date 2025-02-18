import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thunder/features/notification/models/data/notification_data.dart';
part 'notification_state.freezed.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default(true) bool isReceiveBodyCheckCompleted,
    @Default(true) bool isReceiveRatingRequest,
    @Default(true) bool isMarketingAgreed,
  }) = _NotificationState;

  factory NotificationState.fromData(NotificationData data) =>
      NotificationState(
        isReceiveBodyCheckCompleted: data.isReceiveBodyCheckCompleted,
        isReceiveRatingRequest: data.isReceiveBodyCheckRequest,
        isMarketingAgreed: data.isMarketingAgreement,
      );
}
