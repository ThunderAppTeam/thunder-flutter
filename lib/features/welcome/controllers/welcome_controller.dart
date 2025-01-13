import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/constants/time_consts.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';

final welcomeControllerProvider =
    StateNotifierProvider<WelcomeController, int>((ref) {
  return WelcomeController();
});

class WelcomeController extends StateNotifier<int> {
  WelcomeController() : super(0) {
    _startImageTransition();
  }

  Timer? _timer;

  final List<AssetGenImage> images = [
    Assets.images.welcome.pinSelfieWoman1,
    Assets.images.welcome.pinSelfieMan1,
  ];

  void _startImageTransition() {
    _timer = Timer.periodic(
      Duration(seconds: TimeConsts.welcomeImageTransitionInterval),
      (timer) {
        state = (state + 1) % images.length;
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
