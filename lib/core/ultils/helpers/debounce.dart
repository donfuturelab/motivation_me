import 'dart:async';

import 'package:flutter/material.dart';

// Timer? debounceX(Timer? timer, Duration duration, void Function() callback) {
//   timer?.cancel();
//   return Timer(duration, callback);
// }

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }
}
