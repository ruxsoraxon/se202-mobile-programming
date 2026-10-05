// Task 5: Dialogs & Modals (AlertDialog & showModalBottomSheet)
// Run: flutter run -t lib/task5_dialogs.dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: DialogsScreen()));

class DialogsScreen extends StatefulWidget {
  const DialogsScreen({super.key});

  @override
  State<DialogsScreen> createState() => _DialogsScreenState();
}

class _DialogsScreenState extends State<DialogsScreen> {
  List<String> items = ['Photo 1', 'Photo 2', 'Photo 3'];

  // Exercise 5.1: confirmation dialog, returns true when Delete is pressed
  Future<void> _confirmDelete(int index) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('"${items[index]}" will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (delete == true) setState(() => items.removeAt(index));
  }

  // Exercise 5.2: bottom sheet with share options
  void _showShareSheet(String item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in const [
            (Icons.message, 'Telegram'),
            (Icons.email, 'Email'),
            (Icons.link, 'Copy link'),
          ])
            ListTile(
              leading: Icon(option.$1),
              title: Text(option.$2),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(content: Text('Shared $item via ${option.$2}')),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialogs')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(items[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _showShareSheet(items[index]),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _confirmDelete(index),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
