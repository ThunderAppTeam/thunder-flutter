import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thunder/features/auth/repositories/auth_repository.dart';

void main() {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  test(
      'AuthRepository instance should be the same inside and outside ProviderScope',
      () async {
    // Initialize AuthRepository outside of ProviderScope
    final authRepository = AuthRepository(FlutterSecureStorage(), Dio());
    await authRepository.loadAuthData();

    // Create a ProviderContainer with the initialized AuthRepository
    final container = ProviderContainer(
      overrides: [
        authRepoProvider.overrideWithValue(authRepository),
      ],
    );

    // Read the AuthRepository from the ProviderScope
    final authRepoInsideScope = container.read(authRepoProvider);

    // Check if the instance inside the ProviderScope is the same as the one outside
    expect(authRepoInsideScope, same(authRepository));

    // Clean up the ProviderContainer
    container.dispose();
  });
}
