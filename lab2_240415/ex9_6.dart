/// SE202 Mobile Programming — Lab 2, Exercise 9.6
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

class Logger {
  final List<String> lines = [];

  void log(String message) {
    lines.add(message);
    print('LOG: $message');
  }
}

// implements: takes only the TYPE of Logger, every member must be rewritten.
class SilentLogger implements Logger {
  @override
  final List<String> lines = [];

  @override
  void log(String message) => lines.add(message);
}

// with: reuses the CODE of the mixin, nothing to rewrite.
mixin Logging {
  void log(String message) => print('[$runtimeType] $message');
}

class OrderService with Logging {
  void placeOrder() => log('order placed');
}

void main() {
  final Logger a = SilentLogger();
  a.log('hidden');
  print(a.lines);

  OrderService().placeOrder();

  print(SilentLogger() is Logger); // true
  print(OrderService() is Logging); // true
}
