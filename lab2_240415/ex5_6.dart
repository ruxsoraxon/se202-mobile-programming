/// SE202 Mobile Programming — Lab 2, Exercise 5.6
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

// Every public class, constructor, field and method has a /// comment,
// so `dart doc` can generate a complete API reference for it.

/// A single task in a [TodoList].
class Todo {
  /// Creates a task with the given [title].
  Todo(this.title);

  /// Short description of the task.
  final String title;

  /// Whether the task has been completed.
  bool done = false;
}

/// Stores [Todo] items and lets you add, complete and list them.
class TodoList {
  final List<Todo> _items = [];

  /// Number of tasks in the list.
  int get length => _items.length;

  /// Adds a new task with [title] and returns it.
  Todo add(String title) {
    final todo = Todo(title);
    _items.add(todo);
    return todo;
  }

  /// Marks the task at [index] as done.
  ///
  /// Throws a [RangeError] if [index] is out of range.
  void complete(int index) {
    _items[index].done = true;
  }

  /// Tasks that are not done yet.
  List<Todo> get pending => _items.where((t) => !t.done).toList();
}

void main() {
  final list = TodoList();
  list.add('Finish Lab 2');
  list.add('Read Flutter docs');
  list.complete(0);
  print('Total: ${list.length}');
  print('Pending: ${list.pending.map((t) => t.title).toList()}');
}
