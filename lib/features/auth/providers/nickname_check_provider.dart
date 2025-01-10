import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/auth/models/domain/nickname_check_state.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

class NicknameCheckNotifier extends StateNotifier<NicknameCheckState> {
  NicknameCheckNotifier(this._repository) : super(const NicknameCheckState());

  final AuthRepository _repository;

  Future<void> checkAvailability(String nickname) async {
    state = state.copyWith(isLoading: true, isAvailable: false, error: null);
    try {
      await _repository.checkNicknameAvailability(nickname);
      state = state.copyWith(isLoading: false, isAvailable: true);
    } on NicknameCheckError catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}

final nicknameCheckProvider =
    StateNotifierProvider<NicknameCheckNotifier, NicknameCheckState>((ref) {
  return NicknameCheckNotifier(ref.read(authRepoProvider));
});
