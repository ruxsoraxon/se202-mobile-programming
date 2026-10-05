// Task 3: Buttons & Action Items (FloatingActionButton & ElevatedButton)
// Run: flutter run -t lib/task3_buttons.dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: CounterScreen()));

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$counter', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            // Exercise 3.2
            OutlinedButton(
              onPressed: () => setState(() => counter = 0),
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
      // Exercise 3.1: FAB sits in the bottom-right corner by default
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => counter++),
        child: const Icon(Icons.add),
      ),
    );
  }
}
