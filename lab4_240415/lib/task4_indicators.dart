// Task 4: Indicators & Feedback (CircularProgressIndicator & SnackBar)
// Run: flutter run -t lib/task4_indicators.dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: LoadingScreen()));

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool loading = false;
  int savedCount = 0;

  // Exercise 4.1: show the spinner for 3 seconds
  Future<void> _save() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() {
      loading = false;
      savedCount++;
    });

    // Exercise 4.2: SnackBar with an Undo action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Saved'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => savedCount--),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Saved $savedCount times'),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _save, child: const Text('Save')),
                ],
              ),
      ),
    );
  }
}
