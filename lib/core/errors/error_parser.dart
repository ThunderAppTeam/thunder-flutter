import 'package:dio/dio.dart';
import 'package:thunder/core/constants/key_contsts.dart';
import 'package:thunder/core/errors/network_error.dart';
import 'package:thunder/core/errors/server_error.dart';

class ErrorParser {
  static Object parseDio(DioException e) {
    if (e.error is NetworkError) {
      return e.error as NetworkError;
    }
    // (1) response가 null이거나 형식이 맞지 않는 경우 -> invalidResponse
    if (e.response == null || e.response?.data is! Map<String, dynamic>) {
      return ServerError.invalidResponse;
    }

    final data = e.response!.data as Map<String, dynamic>;
    final errorCode = data[KeyConsts.errorCode];

    // (2) errorCode가 제대로 없으면 -> invalidResponse
    if (errorCode == null) {
      return ServerError.invalidResponse;
    }
    // (3) ServerError.fromString 으로 변환
    return ServerErrorX.fromString(errorCode);
  }
}
