import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thunder/core/constants/key_contsts.dart';

class TokenManager {
  final _storage = const FlutterSecureStorage();
  String? _cachedToken;

  String? get token => _cachedToken;

  Future<void> setToken(String token) async {
    await _storage.write(key: KeyConsts.accessToken, value: token);
    _cachedToken = token;
  }

  Future<void> clearToken() async {
    await _storage.delete(key: KeyConsts.accessToken);
    _cachedToken = null;
  }

  Future<void> initialize() async {
    _cachedToken = await _storage.read(key: KeyConsts.accessToken);
    log('AccessToken: $_cachedToken');
  }
}

final tokenManagerProvider = Provider<TokenManager>((ref) {
  return TokenManager();
});
