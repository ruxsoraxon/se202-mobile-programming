import 'package:flutter/material.dart';

class AppRoutes {
  static const home = '/';
  static const profile = '/profile';
  static const messages = '/messages';
  static const about = '/about';
}

void main() {
  runApp(MaterialApp(
    initialRoute: AppRoutes.home,
    routes: {
      AppRoutes.home: (c) => const HomeScreen(),
      AppRoutes.profile: (c) => const PageScreen(title: 'Profile'),
      AppRoutes.messages: (c) => const PageScreen(title: 'Messages'),
      AppRoutes.about: (c) => const PageScreen(title: 'About'),
    },
    onUnknownRoute: (settings) =>
    MaterialPageRoute(builder: (c) => const NotFoundScreen()),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = {
      'Profile': AppRoutes.profile,
      'Messages': AppRoutes.messages,
      'About': AppRoutes.about,
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        children: [
          for (final e in items.entries)
            ListTile(
              title: Text(e.key),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, e.value),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                child: const Text('Open broken link'),
                onPressed: () => Navigator.pushNamed(context, '/does-not-exist'),
              ),
            ),
        ],
        
      ),
    );
  }
}

class PageScreen extends StatelessWidget {
  final String title;
  const PageScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title, style: const TextStyle(fontSize: 24))),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Page not found', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('Back'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}