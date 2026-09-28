/// SE202 Mobile Programming — Lab 2, Exercise 6.3
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

class Student {
  final String name;
  final double gpa;
  Student(String name, double gpa)
      : assert(gpa >= 0 && gpa <= 4.0, 'GPA must be 0..4'),
        name = name.trim(),
        gpa = gpa;
}

void main() {
  final s = Student('  Ali ', 3.5);
  print('${s.name} ${s.gpa}');
}
