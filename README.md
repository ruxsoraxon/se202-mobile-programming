# SE202 Mobile Programming — NewUU

**Ruxsoraxon Kenjayeva** · Student ID **240415** · Software Engineering

---

## Lab 2: Dart Programming

New Uzbekistan University · Department of Computer Science & Software Engineering
Professor: Mukhkammadali Khayotov · Dart 3.x

Lab 2 workbook solutions:

- **Sections 1–4** — four exercises from each category.
- **Sections 5–12** — five exercises from each category.

Exercise 1 of every category was given as a worked example in the handout.

## Contents

| File | Section | Exercise |
|------|---------|----------|
| `lab2_240415/ex1_2.dart` | Main Function | Print full name, student ID and major |
| `lab2_240415/ex1_3.dart` | Main Function | Count and display command-line arguments |
| `lab2_240415/ex1_4.dart` | Main Function | Arithmetic average of numeric arguments |
| `lab2_240415/ex1_5.dart` | Main Function | Validate that exactly two arguments are given |
| `lab2_240415/ex2_2.dart` | Variables & Data Types | int, double, String and bool declarations |
| `lab2_240415/ex2_3.dart` | Variables & Data Types | `final` vs `const` with `DateTime.now()` |
| `lab2_240415/ex2_4.dart` | Variables & Data Types | Null safety with `??` and `??=` |
| `lab2_240415/ex2_6.dart` | Variables & Data Types | Record type storing a 3D coordinate |
| `lab2_240415/ex3_2.dart` | Control Flow | Positive / negative / zero with if-else |
| `lab2_240415/ex3_3.dart` | Control Flow | Factorial with `for` and `for-in` loops |
| `lab2_240415/ex3_4.dart` | Control Flow | Guess-the-number `while` loop with `break` |
| `lab2_240415/ex3_5.dart` | Control Flow | Labeled `break` and `continue` in nested loops |
| `lab2_240415/ex4_2.dart` | Functions / Methods | Arrow function `isEven(int n)` |
| `lab2_240415/ex4_3.dart` | Functions / Methods | Optional positional parameters |
| `lab2_240415/ex4_4.dart` | Functions / Methods | Higher-order function with a transformer callback |
| `lab2_240415/ex4_5.dart` | Functions / Methods | Recursive Fibonacci |
| `lab2_240415/ex5_2.dart` | Comments & Documentation | Single-line and multi-line comments on a calculation |
| `lab2_240415/ex5_3.dart` | Comments & Documentation | Dartdoc for a validation utility (params, return, exceptions) |
| `lab2_240415/ex5_4.dart` | Comments & Documentation | Markdown inside a Dartdoc comment |
| `lab2_240415/ex5_5.dart` | Comments & Documentation | `@Deprecated` and `@override` with doc comments |
| `lab2_240415/ex5_6.dart` | Comments & Documentation | Fully documented API class for `dart doc` |
| `lab2_240415/ex6_2.dart` | Classes & Constructors | `Person` class with a standard constructor |
| `lab2_240415/ex6_3.dart` | Classes & Constructors | Initializer list validating input |
| `lab2_240415/ex6_4.dart` | Classes & Constructors | Singleton with a private constructor and factory |
| `lab2_240415/ex6_5.dart` | Classes & Constructors | Getter and setter enforcing constraints |
| `lab2_240415/ex6_6.dart` | Classes & Constructors | Immutable class with `const` constructor and `final` fields |
| `lab2_240415/ex7_2.dart` | Enums | `Day` enum iterated with `Day.values` |
| `lab2_240415/ex7_3.dart` | Enums | Enum to display string with a switch expression |
| `lab2_240415/ex7_4.dart` | Enums | Enhanced enum implementing an interface |
| `lab2_240415/ex7_5.dart` | Enums | Safe parsing with `Day.values.byName()` |
| `lab2_240415/ex7_6.dart` | Enums | Generic enum with static helper methods |
| `lab2_240415/ex8_2.dart` | Inheritance | `Dog` overriding `Animal.makeSound()` |
| `lab2_240415/ex8_3.dart` | Inheritance | Super-initializer parameters (`super.brand`) |
| `lab2_240415/ex8_5.dart` | Inheritance | Abstract base class with concrete and abstract methods |
| `lab2_240415/ex9_3.dart` | Mixins & Interfaces | `Flyable` mixin applied to `Bird` |
| `lab2_240415/ex9_4.dart` | Mixins & Interfaces | `Walker`, `Swimmer`, `Flyable` on one `Duck` |
| `lab2_240415/ex9_5.dart` | Mixins & Interfaces | Restricting a mixin with `on` |
| `lab2_240415/ex10_2.dart` | Polymorphism | `area()` called on a list of shapes |
| `lab2_240415/ex10_3.dart` | Polymorphism | Type checks with `is` and casts with `as` |
| `lab2_240415/ex10_5.dart` | Polymorphism | Sealed classes with an exhaustive switch |
| `lab2_240415/ex11_2.dart` | Async Operations | Simulated database lookup with a 2-second delay |
| `lab2_240415/ex11_3.dart` | Async Operations | `Future.wait()` running three tasks concurrently |
| `lab2_240415/ex11_5.dart` | Async Operations | Stream `map()`, `where()` and `distinct()` |
| `lab2_240415/ex12_2.dart` | Exceptions & Error Handling | Integer division by zero caught as `UnsupportedError` |
| `lab2_240415/ex12_3.dart` | Exceptions & Error Handling | `ArgumentError` for a null or empty string |
| `lab2_240415/ex12_4.dart` | Exceptions & Error Handling | Specific `on` clauses before a generic `catch` |

## Running

Each file is a standalone Dart program — no `pubspec.yaml` required.

```bash
dart run lab2_240415/ex1_2.dart
dart run lab2_240415/ex1_4.dart 10 20 30   # exercises 1.3–1.5 take command-line arguments
```
