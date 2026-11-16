import 'package:flutter/material.dart';
import 'screens/classifier_page.dart';

void main() => runApp(const FlowerClassifierApp());

class FlowerClassifierApp extends StatelessWidget {
  const FlowerClassifierApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Bloom · Flower ID',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF28745C),
            brightness: Brightness.light,
            surface: const Color(0xFFF8F8F2),
          ),
          scaffoldBackgroundColor: const Color(0xFFF8F8F2),
          fontFamily: 'Roboto',
        ),
        home: const ClassifierPage(),
      );
}
