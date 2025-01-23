import 'package:dio/dio.dart';
import 'package:thunder/core/constants/key_contst.dart';

class DioOptions {
  static Options get tokenOptions => Options(
        contentType: 'application/json',
        responseType: ResponseType.json,
        extra: {KeyConst.requiresToken: true},
      );

  static Options get multipartTokenOptions => Options(
        contentType: 'multipart/form-data',
        responseType: ResponseType.json,
        extra: {KeyConst.requiresToken: true},
      );
}
