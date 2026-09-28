/// SE202 Mobile Programming — Lab 2, Exercise 10.6
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

abstract interface class SortStrategy {
  List<int> sort(List<int> data);
}

class AscendingSort implements SortStrategy {
  @override
  List<int> sort(List<int> data) => [...data]..sort();
}

class DescendingSort implements SortStrategy {
  @override
  List<int> sort(List<int> data) => [...data]..sort((a, b) => b.compareTo(a));
}

class Sorter {
  SortStrategy strategy;
  Sorter(this.strategy);

  List<int> run(List<int> data) => strategy.sort(data);
}

void main() {
  final data = [5, 2, 9, 1];
  final sorter = Sorter(AscendingSort());
  print(sorter.run(data));

  sorter.strategy = DescendingSort(); // swap behaviour at runtime
  print(sorter.run(data));
}
