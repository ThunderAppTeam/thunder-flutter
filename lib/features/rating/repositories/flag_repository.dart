import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/network/dio_error_parser.dart';
import 'package:thunder/core/network/dio_options.dart';
import 'package:thunder/core/network/dio_provider.dart';

class FlagRepository {
  final Dio _dio;

  FlagRepository(this._dio);

  Future<void> flag(int bodyPhotoId, String flagReasonString) async {
    final path = '/v1/flag';
    await _dio.post(path, options: DioOptions.tokenOptions, data: {
      KeyConst.bodyPhotoId: bodyPhotoId,
      KeyConst.flagReason: flagReasonString,
    });
  }

  Future<List<Map<String, dynamic>>> fetchFlagList() async {
    final path = '/v1/flag';
    try {
      final response = await _dio.get(path, options: DioOptions.tokenOptions);
      final data = response.data[KeyConst.data];
      return List<Map<String, dynamic>>.from(data);
    } on DioException catch (e) {
      throw DioErrorParser.parseDio(e);
    }
  }

  Future<void> block(int memberId) async {
    final path = '/v1/member/block';
    await _dio.post(path, options: DioOptions.tokenOptions, data: {
      KeyConst.blockedMemberId: memberId,
    });
  }
}

final flagRepositoryProvider = Provider<FlagRepository>((ref) {
  return FlagRepository(ref.read(dioProvider));
});
