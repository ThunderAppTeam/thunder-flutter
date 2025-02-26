import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Function? onPaused;
  final Function? onResumed;
  final Function? onInactive;
  final Function? onDetached;
  final Function? onHidden;

  LifecycleEventHandler({
    this.onPaused,
    this.onResumed,
    this.onInactive,
    this.onDetached,
    this.onHidden,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        onPaused?.call();
        break;
      case AppLifecycleState.resumed:
        onResumed?.call();
        break;
      case AppLifecycleState.inactive:
        onInactive?.call();
        break;
      case AppLifecycleState.detached:
        onDetached?.call();
        break;
      case AppLifecycleState.hidden:
        onHidden?.call();
        break;
    }
  }
}
