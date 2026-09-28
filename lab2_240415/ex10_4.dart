/// SE202 Mobile Programming — Lab 2, Exercise 10.4
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

class Repository<T> {
  final Map<int, T> _items = {};
  int _nextId = 1;

  int add(T item) {
    _items[_nextId] = item;
    return _nextId++;
  }

  T? getById(int id) => _items[id];

  List<T> getAll() => _items.values.toList();
}

class User {
  final String name;
  User(this.name);

  @override
  String toString() => 'User($name)';
}

void main() {
  final users = Repository<User>();
  final id = users.add(User('Ali'));
  users.add(User('Vali'));
  print(users.getById(id));
  print(users.getAll());

  final numbers = Repository<int>();
  numbers.add(42);
  print(numbers.getAll());
}
