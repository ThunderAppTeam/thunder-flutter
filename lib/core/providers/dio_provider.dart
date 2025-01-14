import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = dotenv.env['BASE_URL']!;

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5), // 연결 시도는 좀 더 여유있게
    receiveTimeout: const Duration(seconds: 10), // 데이터 수신도 여유있게
    sendTimeout: const Duration(seconds: 10),
  ));

  // Add interceptors if needed
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      // Add headers or modify request
      log('Request[${options.method}] => PATH: ${options.path}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      // Handle response
      log('Response[${response.statusCode}] => RESPONSE: ${response.data}');
      return handler.next(response);
    },
    onError: (DioException e, handler) {
      // Handle errors
      log('Error[${e.response?.statusCode}] => RESPONSE: ${e.response?.data}');
      return handler.next(e);
    },
  ));

  return dio;
});
