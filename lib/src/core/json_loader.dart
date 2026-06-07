import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class JsonTranslationLoader {
  /// JSON dosyasından çevirileri yükler
  static Future<Map<String, Map<String, String>>> loadFromAssets({
    required String assetsPath,
    required List<String> locales,
  }) async {
    final Map<String, Map<String, String>> translations = {};

    for (final locale in locales) {
      try {
        final jsonString =
            await rootBundle.loadString('$assetsPath/$locale.json');
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

        // Map<String, dynamic> -> Map<String, String> dönüşümü
        translations[locale] =
            jsonMap.map((key, value) => MapEntry(key, value.toString()));
      } catch (e) {
        debugPrint('LingoEasy: $locale.json yüklenemedi - $e');
        translations[locale] = {};
      }
    }

    return translations;
  }
}
