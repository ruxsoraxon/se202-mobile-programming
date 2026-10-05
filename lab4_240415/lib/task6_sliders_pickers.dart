// Task 6: Sliders & Pickers (Slider & showDatePicker)
// Run: flutter run -t lib/task6_sliders_pickers.dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: VolumeScreen()));

class VolumeScreen extends StatefulWidget {
  const VolumeScreen({super.key});

  @override
  State<VolumeScreen> createState() => _VolumeScreenState();
}

class _VolumeScreenState extends State<VolumeScreen> {
  double volume = 0.5; // 0.0 .. 1.0
  DateTime? pickedDate;

  // Exercise 6.2: native date picker
  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: pickedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => pickedDate = date);
  }

  String _format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Volume')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Exercise 6.1: slider updates the percentage text
            Row(
              children: [
                Icon(volume == 0 ? Icons.volume_off : Icons.volume_up),
                Expanded(
                  child: Slider(
                    value: volume,
                    onChanged: (value) => setState(() => volume = value),
                  ),
                ),
                Text('${(volume * 100).round()}%'),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: const Text('Pick a date'),
            ),
            const SizedBox(height: 12),
            Text(pickedDate == null ? 'No date selected' : _format(pickedDate!)),
          ],
        ),
      ),
    );
  }
}
