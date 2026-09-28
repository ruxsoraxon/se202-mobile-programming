/// SE202 Mobile Programming — Lab 2, Exercise 6.6
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

class Money {
  final int amount;
  final String currency;

  const Money(this.amount, this.currency);

  // Immutable: instead of changing this object, return a new one.
  Money add(Money other) => Money(amount + other.amount, currency);

  @override
  String toString() => '$amount $currency';
}

void main() {
  const a = Money(100, 'UZS');
  const b = Money(100, 'UZS');
  print(identical(a, b)); // true: equal const objects are shared
  print(a.add(const Money(50, 'UZS')));
  print(a); // still 100 UZS
}
