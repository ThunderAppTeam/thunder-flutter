import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thunder/core/constants/key_contst.dart';

class TokenProvider {
  final _storage = const FlutterSecureStorage();
  String? _cachedToken;

  String? get token => _cachedToken;

  Future<void> setToken(String token) async {
    await _storage.write(key: KeyConst.accessToken, value: token);
    _cachedToken = token;
  }

  Future<void> clearToken() async {
    await _storage.delete(key: KeyConst.accessToken);
    _cachedToken = null;
  }

  Future<void> initialize() async {
    _cachedToken = await _storage.read(key: KeyConst.accessToken);
    log('AccessToken: $_cachedToken');
  }
}

final tokenProvider = Provider<TokenProvider>((ref) {
  return TokenProvider();
});
