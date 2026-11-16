import 'package:flutter/material.dart';

import 'screens/app_shell.dart';
import 'screens/welcome_page.dart';
import 'services/flower_classifier.dart';
import 'theme/app_theme.dart';

void main() => runApp(const FlowerClassifierApp());

class FlowerClassifierApp extends StatefulWidget {
  const FlowerClassifierApp({super.key});

  @override
  State<FlowerClassifierApp> createState() => _FlowerClassifierAppState();
}

class _FlowerClassifierAppState extends State<FlowerClassifierApp> {
  FlowerClassifier? _classifier;
  Object? _loadError;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final classifier = await FlowerClassifier.load();
      if (!mounted) {
        classifier.close();
        return;
      }
      setState(() {
        _classifier = classifier;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _classifier?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Bloom · Flower ID',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: _loading
            ? const _StartupPage()
            : _classifier == null
                ? _ModelErrorPage(error: _loadError, onRetry: _loadModel)
                : Builder(
                    builder: (navigatorContext) => WelcomePage(
                      classifier: _classifier!,
                      onContinue: () =>
                          Navigator.of(navigatorContext).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => AppShell(classifier: _classifier!),
                        ),
                      ),
                    ),
                  ),
      );
}

class _StartupPage extends StatelessWidget {
  const _StartupPage();

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BloomMark(size: 68),
              SizedBox(height: 20),
              Text('Getting Bloom ready…'),
              SizedBox(height: 16),
              SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ),
        ),
      );
}

class _ModelErrorPage extends StatelessWidget {
  const _ModelErrorPage({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.broken_image_outlined, size: 48),
                  const SizedBox(height: 16),
                  Text('Bloom could not load its model',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('$error', textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _BloomMark extends StatelessWidget {
  const _BloomMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(size * .32),
        ),
        child: Icon(Icons.local_florist_rounded,
            size: size * .55, color: Colors.white),
      );
}
