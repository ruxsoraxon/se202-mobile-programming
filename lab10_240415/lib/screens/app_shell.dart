import 'package:flutter/material.dart';

import '../models/classification_record.dart';
import '../services/flower_classifier.dart';
import 'classifier_page.dart';
import 'history_page.dart';
import 'home_page.dart';
import 'model_page.dart';
import 'result_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({required this.classifier, super.key});

  final FlowerClassifier classifier;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  final List<ClassificationRecord> _history = [];

  void _startClassification() {
    Navigator.of(context).push<void>(MaterialPageRoute(
      builder: (_) => ClassifierPage(
        classifier: widget.classifier,
        onClassified: (record) {
          setState(() => _history.insert(0, record));
        },
      ),
    ));
  }

  void _openRecord(ClassificationRecord record) {
    Navigator.of(context).push<void>(MaterialPageRoute(
      builder: (_) => ResultPage(record: record),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(
        classCount: widget.classifier.labels.length,
        history: _history,
        onClassify: _startClassification,
        onOpenRecord: _openRecord,
        onOpenHistory: () => setState(() => _selectedIndex = 1),
      ),
      HistoryPage(records: _history, onOpenRecord: _openRecord),
      ModelPage(classifier: widget.classifier),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.model_training_outlined),
            label: 'Model',
          ),
        ],
      ),
    );
  }
}
