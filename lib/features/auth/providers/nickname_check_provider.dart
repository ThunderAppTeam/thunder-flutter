import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/errors/server_error.dart';
import 'package:thunder/features/auth/models/states/nickname_check_state.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

class NicknameCheckNotifier extends StateNotifier<NicknameCheckState> {
  NicknameCheckNotifier(this._repository) : super(const NicknameCheckState());

  final AuthRepository _repository;

  Future<void> checkAvailability(String nickname) async {
    state = state.copyWith(isLoading: true, isAvailable: false, error: null);
    try {
      await _repository.checkNicknameAvailability(nickname);
      state = state.copyWith(isLoading: false, isAvailable: true);
    } on ServerError catch (e) {
      final error = NicknameCheckError.fromServerError(e);
      state = state.copyWith(isLoading: false, error: error);
    }
  }
}

final nicknameCheckProvider =
    StateNotifierProvider<NicknameCheckNotifier, NicknameCheckState>((ref) {
  return NicknameCheckNotifier(ref.read(authRepoProvider));
});
