// Task 8: Grid Displays (GridView.count)
// Run: flutter run -t lib/task8_grid.dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: GalleryScreen()));

// Colors stand in for images so the lab runs without asset files
const galleryColors = [
  Colors.red, Colors.orange, Colors.amber, Colors.green,
  Colors.teal, Colors.blue, Colors.indigo, Colors.purple,
];

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      // Exercise 8.1: 2 columns with spacing
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (var i = 0; i < galleryColors.length; i++)
            // Exercise 8.2: tap opens a full-screen preview
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PreviewScreen(index: i, color: galleryColors[i]),
                ),
              ),
              child: Container(
                color: galleryColors[i],
                child: Center(
                  child: Text('Photo ${i + 1}',
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  final int index;
  final Color color;

  const PreviewScreen({super.key, required this.index, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo ${index + 1}')),
      body: Container(color: color),
    );
  }
}
