import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contsts.dart';
import 'package:thunder/core/errors/network_error.dart';
import 'package:thunder/core/services/token_manager.dart';

class AuthInterceptor extends Interceptor {
  final Ref _ref;

  AuthInterceptor(this._ref);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final requiresAuth =
        options.extra[KeyConsts.requiresAuth] as bool? ?? false;
    if (requiresAuth) {
      final accessToken = _ref.read(tokenManagerProvider).token;

      if (accessToken == null) {
        log('No access token');
        return handler.reject(
          DioException(
            requestOptions: options,
            error: NetworkError.unauthorized,
            type: DioExceptionType.cancel,
          ),
        );
      }

      options.headers[KeyConsts.authorization] = 'Bearer $accessToken';
    }

    handler.next(options);
  }
}
