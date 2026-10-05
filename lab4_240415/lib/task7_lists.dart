// Task 7: Scrollable Collections (ListView.builder & ListTile)
// Run: flutter run -t lib/task7_lists.dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: ItemsScreen()));

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  // Exercise 7.1: 20 items
  final items = List.generate(20, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      // builder only creates the tiles that are visible (lazy loading)
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          // Exercise 7.2: swipe to dismiss; the key must be unique per item
          return Dismissible(
            key: ValueKey(item),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              setState(() => items.removeAt(index));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$item removed')),
              );
            },
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(item),
              subtitle: const Text('Swipe left to delete'),
            ),
          );
        },
      ),
    );
  }
}
