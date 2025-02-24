import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/network/dio_options.dart';
import 'package:thunder/core/network/dio_provider.dart';
import 'package:thunder/core/network/repository/base_repository.dart';

class MemberRepository extends BaseRepository {
  MemberRepository(super.dio);

  Future<Map<String, dynamic>> getMemberInfo() async {
    final path = '/v1/member/info';
    return get(path, options: DioOptions.tokenOptions);
  }
}

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return MemberRepository(ref.read(dioProvider));
});
