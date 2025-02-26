import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/errors/network_error.dart';
import 'package:thunder/core/providers/token_provider.dart';
import 'package:thunder/core/services/log_service.dart';

class DioAuthInterceptor extends Interceptor {
  final Ref _ref;

  DioAuthInterceptor(this._ref);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final requiresToken =
        options.extra[KeyConst.requiresToken] as bool? ?? false;
    if (requiresToken) {
      final accessToken = _ref.read(tokenProvider).token;

      if (accessToken == null) {
        LogService.error('No access token');
        return handler.reject(
          DioException(
            requestOptions: options,
            error: NetworkError.unauthorized,
            type: DioExceptionType.cancel,
          ),
        );
      }

      options.headers[KeyConst.authorization] = 'Bearer $accessToken';
    }

    handler.next(options);
  }
}
