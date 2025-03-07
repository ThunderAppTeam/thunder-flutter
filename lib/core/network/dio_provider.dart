import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/network/dio_auth_interceptor.dart';
import 'package:thunder/core/services/log_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = dotenv.env['BASE_URL']!;

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
  ));

  // (1) 로그 Interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      LogService.debug('Request[${options.method}] => PATH: ${options.path} '
          'PARAMS: ${options.queryParameters} DATA: ${options.data}');
      handler.next(options); // 요청을 다음 Interceptor로 넘김
    },
    onResponse: (response, handler) {
      LogService.trace(
          'Response[${response.statusCode}] => RESPONSE: ${response.data}');

      handler.next(response); // 응답 처리 완료
    },
    onError: (DioException e, handler) {
      LogService.error(
          'Error[${e.response?.statusCode}] => RESPONSE: ${e.response?.data} ERROR: ${e.error}');

      handler.next(e); // 에러 전달
    },
  ));

  dio.interceptors.add(DioAuthInterceptor(ref));

  return dio;
});
