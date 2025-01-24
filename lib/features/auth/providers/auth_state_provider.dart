import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';

class AuthState {
  final bool isLoggedIn;

  AuthState({required this.isLoggedIn});

  AuthState copyWith({bool? isLoggedIn}) {
    return AuthState(isLoggedIn: isLoggedIn ?? this.isLoggedIn);
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.read(authRepoProvider);
    return AuthState(isLoggedIn: _authRepository.isLoggedIn);
  }

  void login() {
    state = state.copyWith(isLoggedIn: true);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = state.copyWith(isLoggedIn: false);
  }
}

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
