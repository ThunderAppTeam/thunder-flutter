import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/services/analytics_service.dart';
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

  void login(int memberId) {
    state = state.copyWith(isLoggedIn: true);
    AnalyticsService.setUserId(memberId.toString());
  }

  void logout() {
    state = state.copyWith(isLoggedIn: false);
    AnalyticsService.resetUserId();
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    logout();
    AnalyticsService.logout();
  }
}

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
