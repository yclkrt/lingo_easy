import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_easy/lingo_easy.dart';

// NOT: JsonTranslationLoader testleri için ayrı bir test yaz
// Şimdilik basit testlerle devam et

void main() {
  group('LingoController Testleri', () {
    late TranslationMap translationMap;
    late LingoController controller;

    setUp(() {
      final translations = {
        'tr': {
          'hello': 'Merhaba',
          'welcome': 'Hoş geldiniz, {name}!',
        },
        'en': {
          'hello': 'Hello',
          'welcome': 'Welcome, {name}!',
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

    test('Çeviri doğru dönmeli', () {
      expect(controller.translate('hello'), 'Merhaba');

      controller.setLocale('en');
      expect(controller.translate('hello'), 'Hello');
    });

    test('Parametreli çeviri çalışmalı', () {
      final result = controller.translate(
        'welcome',
        params: {'name': 'Ahmet'},
      );
      expect(result, 'Hoş geldiniz, Ahmet!');
    });
  });

  group('TranslationMap Testleri', () {
    test('Yeni dil dinamik olarak eklenebilmeli', () {
      final translations = {
        'tr': {'hello': 'Merhaba'},
      };
      final map = TranslationMap(translations);

      map.addLocale('fr', {'hello': 'Bonjour'});

      expect(map.hasLocale('fr'), true);
      expect(map.translate('fr', 'hello'), 'Bonjour');
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
                return Text(context.tr('test'));
              },
            ),
          ),
        ),
      );

      expect(find.text('Çalışıyor'), findsOneWidget);
    });
  });
}
