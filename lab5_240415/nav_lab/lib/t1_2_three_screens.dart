import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      home: Screen(name: 'A', color: Colors.red, next: 'B'),
    ));

class Screen extends StatelessWidget {
  final String name;
  final Color color;
  final String? next;
  const Screen({super.key, required this.name, required this.color, this.next});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Screen $name'), backgroundColor: color),
      body: Center(
        child: next != null
            ? ElevatedButton(
                child: Text('Next → $next'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => _build(next!)),
                ),
              )
            : ElevatedButton(
                child: const Text('Back'),
                onPressed: () => Navigator.pop(context),
              ),
      ),
    );
  }

  static Widget _build(String n) => switch (n) {
        'B' => const Screen(name: 'B', color: Colors.green, next: 'C'),
        _ => const Screen(name: 'C', color: Colors.blue),
      };
}