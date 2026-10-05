// Task 1: Selection Controls (Checkbox & Switch)
// Run: flutter run -t lib/task1_selection_controls.dart
import 'package:flutter/material.dart';

void main() => runApp(const Task1App());

class Task1App extends StatelessWidget {
  const Task1App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SettingsScreen());
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Column(
          children: [
            // Exercise 1.1
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: darkMode,
              onChanged: (value) => setState(() => darkMode = value),
            ),
            CheckboxListTile(
              title: const Text('Agree to Terms'),
              value: agreed,
              onChanged: (value) => setState(() => agreed = value ?? false),
            ),
            const SizedBox(height: 16),
            // Exercise 1.2: onPressed == null disables the button
            ElevatedButton(
              onPressed: agreed
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Continuing...')),
                      )
                  : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
