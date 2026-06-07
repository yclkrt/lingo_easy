import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_easy/lingo_easy.dart';

void main() {
  group('LingoController Testleri', () {
    late TranslationMap translationMap;
    late LingoController controller;

    setUp(() {
      final translations = {
        'tr': {
          'hello': 'Merhaba',
          'welcome': 'Hoş geldiniz, {name}!',
          'farewell': 'Güle güle',
        },
        'en': {
          'hello': 'Hello',
          'welcome': 'Welcome, {name}!',
          'farewell': 'Goodbye',
        },
      };
      translationMap = TranslationMap(translations);
      controller = LingoController(
        defaultLocale: 'tr',
        translationMap: translationMap,
      );
    });

    test('Başlangıç dili doğru ayarlanmalı', () {
      expect(controller.currentLocale, 'tr');
    });

    test('Dil değiştirme çalışmalı', () {
      controller.setLocale('en');
      expect(controller.currentLocale, 'en');
    });

    test('Olmayan dil değişmemeli', () {
      controller.setLocale('de');
      expect(controller.currentLocale, 'tr');
    });

    test('Çeviri doğru dönmeli', () {
      expect(controller.translate('hello'), 'Merhaba');

      controller.setLocale('en');
      expect(controller.translate('hello'), 'Hello');
    });

    test('Olmayan anahtar kendini dönmeli', () {
      expect(controller.translate('unknown_key'), 'unknown_key');
    });

    test('Parametreli çeviri çalışmalı', () {
      final result = controller.translate(
        'welcome',
        params: {'name': 'Ahmet'},
      );
      expect(result, 'Hoş geldiniz, Ahmet!');
    });

    test('Mevcut diller listelenmeli', () {
      expect(controller.availableLocales, contains('tr'));
      expect(controller.availableLocales, contains('en'));
      expect(controller.availableLocales.length, 2);
    });
  });

  group('TranslationMap Testleri', () {
    test('Dinamik dil eklenebilmeli', () {
      final translations = {
        'tr': {'hello': 'Merhaba'},
      };
      final map = TranslationMap(translations);

      map.addLocale('fr', {'hello': 'Bonjour'});

      expect(map.hasLocale('fr'), true);
      expect(map.translate('fr', 'hello'), 'Bonjour');
    });

    test('Olmayan dilde çeviri null dönmeli', () {
      final translations = {
        'tr': {'hello': 'Merhaba'},
      };
      final map = TranslationMap(translations);

      expect(map.translate('de', 'hello'), null);
    });

    test('İç içe geçmiş (nested) haritalar düzleştirilmeli', () {
      final translations = {
        'tr': {
          'home': {
            'title': 'Ana Sayfa',
            'dashboard': {
              'welcome': 'Hoş geldiniz',
            }
          }
        },
      };
      final map = TranslationMap(translations);

      expect(map.translate('tr', 'home.title'), 'Ana Sayfa');
      expect(map.translate('tr', 'home.dashboard.welcome'), 'Hoş geldiniz');
    });
  });

  group('Widget Testleri', () {
    testWidgets('LingoWrapper basic çalışmalı', (tester) async {
      final translations = {
        'tr': {'test': 'Çalışıyor'},
        'en': {'test': 'Working'},
      };

      await tester.pumpWidget(
        MaterialApp(
          home: LingoWrapper(
            defaultLocale: 'tr',
            supportedLocales: ['tr', 'en'],
            translations: translations,
            child: Builder(
              builder: (context) {
                return Text('Test Widget');
              },
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('Dil değiştirme widget ile çalışmalı', (tester) async {
      final translations = {
        'tr': {'message': 'Merhaba'},
        'en': {'message': 'Hello'},
      };

      await tester.pumpWidget(
        MaterialApp(
          home: LingoWrapper(
            defaultLocale: 'tr',
            supportedLocales: ['tr', 'en'],
            translations: translations,
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    Text(context.tr('message')),
                    ElevatedButton(
                      onPressed: () => context.setLocale('en'),
                      child: const Text('Change'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Merhaba'), findsOneWidget);
      expect(find.text('Hello'), findsNothing);

      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Merhaba'), findsNothing);
    });
  });
}
