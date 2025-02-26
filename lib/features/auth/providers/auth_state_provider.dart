import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/services/analytics_service.dart';
import 'package:thunder/core/services/log_service.dart';
import 'package:thunder/features/auth/repositories/auth_repository.dart';
import 'package:thunder/features/notification/services/notification_service.dart';

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
    _authRepository = ref.read(authRepositoryProvider);
    if (_authRepository.isLoggedIn) {
      NotificationService.instance.sendFCMTokenToServer();
    }
    return AuthState(isLoggedIn: _authRepository.isLoggedIn);
  }

  void login(String memberUuid) {
    state = state.copyWith(isLoggedIn: true);
    AnalyticsService.setUserId(memberUuid);
    NotificationService.instance.sendFCMTokenToServer();
  }

  void logout() {
    state = state.copyWith(isLoggedIn: false);
    AnalyticsService.resetUserId();
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      logout();
      AnalyticsService.logout();
    } catch (e) {
      LogService.error('Logout API failed: $e');
    }
  }
}

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
