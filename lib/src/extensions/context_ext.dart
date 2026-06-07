import 'package:flutter/material.dart';
import '../widgets/lingo_wrapper.dart';

extension LingoContextExtension on BuildContext {
  /// Çeviri anahtarı ile çevrilmiş metni döndürür ve dil değişimlerinde widget'ın yeniden derlenmesini sağlar.
  String tr(String key, {Map<String, String>? params}) {
    final controller = LingoWrapper.of(this, listen: true);
    return controller.translate(key, params: params);
  }

  /// Uygulama dilini değiştirir (widget'ın kendisinin yeniden çizilmesini tetiklemez).
  void setLocale(String newLocale) {
    final controller = LingoWrapper.of(this, listen: false);
    controller.setLocale(newLocale);
  }

  /// Aktif dil kodunu döndürür ve dil değişimlerinde widget'ın yeniden derlenmesini sağlar.
  String get currentLocale {
    final controller = LingoWrapper.of(this, listen: true);
    return controller.currentLocale;
  }

  /// Desteklenen dillerin listesini döndürür (rebuild tetiklemez).
  List<String> get availableLocales {
    final controller = LingoWrapper.of(this, listen: false);
    return controller.availableLocales;
  }
}
