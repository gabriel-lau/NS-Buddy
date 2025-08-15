import '../models/counter.dart';

class CounterController {
  final Counter counter;

  CounterController({required this.counter});

  int get value => counter.value;

  void increment() {
    counter.increment();
  }
}
