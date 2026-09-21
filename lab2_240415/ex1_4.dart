/// SE202 Mobile Programming — Lab 2, Exercise 1.4
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('No numbers given.');
    return;
  }
  final nums = arguments.map(double.parse).toList();
  final avg = nums.reduce((a, b) => a + b) / nums.length;
  print('Average: ${avg.toStringAsFixed(2)}');
}
