import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/auth/models/data/deletion_reason_data.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

class DeleteAccountViewModel extends AsyncNotifier<void> {
  late final AuthRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepoProvider);
  }

  Future<List<DeletionReasonData>> getDeletionReasons() async {
    state = const AsyncLoading();
    List<DeletionReasonData> reasons = [];
    state = await AsyncValue.guard(() async {
      final list = await _repository.getDeletionReasons();
      reasons = list.map((e) => DeletionReasonData.fromJson(e)).toList();
    });
    return reasons;
  }

  Future<void> deleteAccount(String reason) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteAccount(reason);
    });
  }
}

final deleteAccountProvider =
    AsyncNotifierProvider<DeleteAccountViewModel, void>(
  () => DeleteAccountViewModel(),
);
