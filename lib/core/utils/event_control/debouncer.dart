import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:thunder/core/services/log_service.dart';

class Debouncer {
  final Duration duration;
  final _isLoadingNotifier = ValueNotifier<bool>(false);
  DateTime? _lastExecutionTime;

  Debouncer({
    this.duration = const Duration(milliseconds: 500),
  });

  ValueNotifier<bool> get isLoadingNotifier => _isLoadingNotifier;

  bool get canExecute {
    if (_lastExecutionTime == null) return true;
    return DateTime.now().difference(_lastExecutionTime!) > duration;
  }

  Future<void> run(Future<void> Function() action) async {
    if (!canExecute) {
      LogService.debug('Debounced: Too soon to execute');
      return;
    }
    _isLoadingNotifier.value = true;
    _lastExecutionTime = DateTime.now();
    try {
      await Future.delayed(duration); // 실제로 지연 시간을 기다림
      await action();
    } catch (e) {
      LogService.error('Debounced: Error executing action: $e');
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  void dispose() {
    _isLoadingNotifier.dispose();
  }
}
