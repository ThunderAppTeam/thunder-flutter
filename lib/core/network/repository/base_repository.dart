import 'package:dio/dio.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/network/dio_error_parser.dart';

mixin BaseRepository {
  Dio get dio;
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data[KeyConst.data];
    } on DioException catch (e) {
      throw DioErrorParser.parseDio(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        options: options,
      );
      return response.data[KeyConst.data];
    } on DioException catch (e) {
      throw DioErrorParser.parseDio(e);
    }
  }

  Future<T> delete<T>(
    String path, {
    Options? options,
  }) async {
    try {
      final response = await dio.delete(
        path,
        options: options,
      );
      return response.data[KeyConst.data];
    } on DioException catch (e) {
      throw DioErrorParser.parseDio(e);
    }
  }
}
