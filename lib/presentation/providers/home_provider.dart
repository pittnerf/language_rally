// lib/presentation/pages/home/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeCounterProvider = NotifierProvider<HomeCounterNotifier, int>(() => HomeCounterNotifier());

class HomeCounterNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }

  void reset() {
    state = 0;
  }
}
