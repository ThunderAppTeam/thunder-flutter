import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/member/models/member_data.dart';
import 'package:thunder/features/member/repositories/member_repository.dart';

class MemberViewModel extends AsyncNotifier<MemberData> {
  late final MemberRepository _memberRepository;

  @override
  Future<MemberData> build() async {
    _memberRepository = ref.read(memberRepositoryProvider);
    state = const AsyncLoading();
    final memberInfo = await _fetchMemberInfo();
    return memberInfo;
  }

  Future<MemberData> _fetchMemberInfo() async {
    try {
      final memberInfo = await _memberRepository.getMemberInfo();
      return MemberData.fromJson(memberInfo);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final memberDataProvider = AsyncNotifierProvider<MemberViewModel, MemberData>(
  () => MemberViewModel(),
);
