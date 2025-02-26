import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/services/log_service.dart';
import 'package:thunder/core/utils/event_control/debouncer.dart';
import 'package:thunder/features/notification/models/data/notification_data.dart';
import 'package:thunder/features/notification/models/state/notification_state.dart';
import 'package:thunder/features/notification/repositories/notification_repository.dart';

class NotificationViewModel extends AsyncNotifier<NotificationState> {
  late final NotificationRepository _repository;
  final Debouncer _debouncer = Debouncer(duration: Duration(seconds: 1));
  @override
  Future<NotificationState> build() async {
    _repository = ref.read(notificationRepositoryProvider);
    ref.onDispose(() {
      _debouncer.dispose();
    });
    state = AsyncValue.loading();
    final settings = await _fetchNotificationData();
    return settings == null
        ? NotificationState()
        : NotificationState.fromData(settings);
  }

  Future<NotificationData?> _fetchNotificationData() async {
    try {
      final data = await _repository.fetchNotificationSettings();
      return NotificationData.fromJson(data);
    } catch (e) {
      LogService.error(
          "NotificationViewModel: _fetchNotificationData error! $e");
      return null;
    }
  }

  Future<void> toggle(NotificationSettingsType type, bool value) async {
    if (!state.hasValue) return;
    var settings = state.value!;

    switch (type) {
      case NotificationSettingsType.bodyCheckCompleted:
        settings = settings.copyWith(isReviewCompletNotify: value);
        break;
      case NotificationSettingsType.ratingRequest:
        settings = settings.copyWith(isReviewRequestNotify: value);
        break;
      case NotificationSettingsType.marketingArgree:
        settings = settings.copyWith(isMarketingAgreement: value);
        break;
    }
    state = AsyncData(settings);

    _debouncer.run(
      () async {
        await Future.delayed(Duration(milliseconds: 300));
        await _repository
            .postNotificationSettings(NotificationData.fromState(settings));
      },
    );
  }
}

enum NotificationSettingsType {
  bodyCheckCompleted,
  ratingRequest,
  marketingArgree,
}

final notificationViewModelProvider =
    AsyncNotifierProvider<NotificationViewModel, NotificationState>(
  () => NotificationViewModel(),
);
