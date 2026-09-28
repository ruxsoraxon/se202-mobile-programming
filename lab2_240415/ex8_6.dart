/// SE202 Mobile Programming — Lab 2, Exercise 8.6
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

// base: can be extended, but not implemented, outside this file.
//       Every subclass must also be base, final or sealed.
base class Account {
  double balance = 0;

  void deposit(double amount) {
    balance += amount;
  }
}

base class SavingsAccount extends Account {
  final double rate;
  SavingsAccount(this.rate);

  void addInterest() {
    balance += balance * rate;
  }
}

// final: cannot be extended or implemented outside this file.
final class Token {
  final String value;
  Token(this.value);
}

// In another file these lines would NOT compile:
//   class FakeAccount implements Account {}   // base class cannot be implemented
//   class FakeToken extends Token {}          // final class cannot be extended
//   class Plain extends Account {}            // subclass of base must be base/final/sealed

void main() {
  final s = SavingsAccount(0.1);
  s.deposit(1000);
  s.addInterest();
  print(s.balance); // 1100.0
  print(Token('abc').value);
}
