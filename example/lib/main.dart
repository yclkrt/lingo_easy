import 'package:flutter/material.dart';
import 'package:lingo_easy/lingo_easy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LingoEasy Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const LingoWrapper(
        defaultLocale: 'tr',
        supportedLocales: ['tr', 'en'],
        assetsPath: 'assets/lang',
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('app_title')),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Parameterized translation
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.waving_hand,
                        size: 40, color: Colors.deepPurple),
                    const SizedBox(height: 12),
                    Text(
                      context.tr('welcome_message', params: {'name': 'Fatih'}),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nested key translation
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nested Key Translation:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr('nested.deep.text'),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Current locale info
            Text(
              'Active Locale: ${context.currentLocale.toUpperCase()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Available Locales: ${context.availableLocales.join(', ').toUpperCase()}',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const Spacer(),

            // Language Switcher Buttons
            ElevatedButton.icon(
              onPressed: () {
                final nextLocale = context.currentLocale == 'tr' ? 'en' : 'tr';
                context.setLocale(nextLocale);
              },
              icon: const Icon(Icons.translate),
              label: Text(context.tr('button.change_language')),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
