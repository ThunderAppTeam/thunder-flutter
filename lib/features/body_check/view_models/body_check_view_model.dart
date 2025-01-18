import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/features/body_check/models/body_check_state.dart';
import 'package:thunder/features/body_check/repsitories/body_check_repository.dart';

class BodyCheckViewModel extends StateNotifier<BodyCheckState> {
  Timer? _timer;
  final Random _random = Random();
  final BodyCheckRepository _repository;

  BodyCheckViewModel(super.state, this._repository);

  Future<void> uploadImage(String imagePath) async {
    state = state.copyWith(isUploading: true, error: null);
    try {
      final imageUrl = await _repository.uploadImage(imagePath);
      state = state.copyWith(imageUrl: imageUrl);
    } catch (e) {
      state =
          state.copyWith(isUploading: false, error: BodyCheckError.uploadImage);
      return;
    }
    state = state.copyWith(isUploading: false);
    startFakeProgress();
  }

  double _getNextScore(
      double currentScore, double targetScore, double progress) {
    // 진행도에 따라 표준편차를 줄여서 목표점수에 수렴하도록 함
    double standardDeviation = (1.0 - (progress / 100)) * 0.5;

    // Box-Muller 변환을 사용한 가우시안 난수 생성
    double u1 = _random.nextDouble();
    double u2 = _random.nextDouble();
    double z = sqrt(-2.0 * log(u1)) * cos(2.0 * pi * u2);

    // 현재 점수에서 목표 점수를 향해 이동
    double step = z * standardDeviation;
    double nextScore = currentScore + (targetScore - currentScore) * 0.1 + step;

    // 점수 범위 제한 (1.0 ~ 10.0)
    return nextScore.clamp(1.0, 10.0);
  }

  void startFakeProgress() {
    _timer?.cancel();
    state = state.copyWith(isFinished: false, progress: 0, currentScore: 0);
    final targetScore = 1 + _random.nextDouble() * 9;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (state.progress >= 100) {
        timer.cancel();

        state = state.copyWith(
          currentScore: targetScore,
          progress: 100,
          isFinished: true,
          genderPercent: 12,
          percent: 12,
          age: 20,
          gender: Gender.female,
        );
        return;
      }

      final newProgress = state.progress + 1;

      final score = _getNextScore(state.currentScore, targetScore, newProgress);
      state = state.copyWith(
        progress: newProgress,
        currentScore: score,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final bodyCheckProvider =
    StateNotifierProvider<BodyCheckViewModel, BodyCheckState>((ref) {
  return BodyCheckViewModel(
      BodyCheckState(), ref.read(bodyCheckRepositoryProvider));
});
