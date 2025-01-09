import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/auth/models/nickname_check_state.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

final nicknameCheckProvider =
    StateNotifierProvider<NicknameCheckNotifier, NicknameCheckState>((ref) {
  return NicknameCheckNotifier(ref);
});

class NicknameCheckNotifier extends StateNotifier<NicknameCheckState> {
  NicknameCheckNotifier(this._ref) : super(const NicknameCheckState());

  final Ref _ref;

  Future<void> checkAvailability(String nickname) async {
    state = state.copyWith(isLoading: true, isAvailable: false, error: null);
    try {
      await _ref.read(authRepoProvider).checkNicknameAvailability(nickname);
      state = state.copyWith(isLoading: false, isAvailable: true);
    } on NicknameCheckError catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}
