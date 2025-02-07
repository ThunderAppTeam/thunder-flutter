import 'package:thunder/core/services/log_service.dart';

class Throttler {
  final Duration duration;
  DateTime? _lastExecutionTime;

  Throttler({
    this.duration = const Duration(milliseconds: 500),
  });

  bool get canExecute {
    final now = DateTime.now();
    if (_lastExecutionTime == null) {
      _lastExecutionTime = now;
      return true;
    }

    if (now.difference(_lastExecutionTime!) > duration) {
      _lastExecutionTime = now;
      return true;
    }

    return false;
  }

  Future<void> run(Future<void> Function() action) async {
    if (!canExecute) {
      LogService.debug('Throttled: Too soon to execute');
      return;
    }

    await action();
  }

  void dispose() {
    _lastExecutionTime = null;
  }
}
