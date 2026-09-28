/// SE202 Mobile Programming — Lab 2, Exercise 7.6
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

enum Setting<T> {
  volume<int>(50),
  darkMode<bool>(false),
  language<String>('uz');

  final T defaultValue;
  const Setting(this.defaultValue);

  static List<String> get keys => values.map((s) => s.name).toList();

  static Setting byKey(String key) => values.byName(key);
}

void main() {
  print(Setting.volume.defaultValue + 10); // T is int here
  print(Setting.darkMode.defaultValue); // T is bool here
  print(Setting.keys);
  print(Setting.byKey('language').defaultValue);
}
