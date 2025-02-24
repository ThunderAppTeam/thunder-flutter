import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:thunder/core/services/log_service.dart';

class Debouncer {
  final Duration duration;
  final _isLoadingNotifier = ValueNotifier<bool>(false);
  Timer? _timer;

  Debouncer({
    this.duration = const Duration(milliseconds: 500),
  });

  ValueNotifier<bool> get isLoadingNotifier => _isLoadingNotifier;

  Future<void> run(Future<void> Function() action) async {
    _timer?.cancel();
    _timer = Timer(
      duration,
      () async {
        if (_isLoadingNotifier.value == false) _isLoadingNotifier.value = true;
        try {
          await action();
        } catch (e) {
          LogService.error('Debounced: Error in Debouncer $e');
        } finally {
          _isLoadingNotifier.value = false;
        }
      },
    );
  }

  void dispose() {
    _timer?.cancel();
    _isLoadingNotifier.dispose();
  }
}
